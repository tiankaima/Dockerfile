"""Simple verifier proxy that fans requests out to configured upstream servers."""

import json
import logging
import os
from http.server import BaseHTTPRequestHandler, HTTPServer
from typing import Dict, List, Tuple
from urllib.error import URLError, HTTPError
from urllib.request import Request, urlopen


logging.basicConfig(level=logging.INFO, format="[%(levelname)s] %(message)s")

# Expected environment vars:
# - servers: comma-separated list or JSON array of upstream verify endpoints
# - HOST / PORT (optional): bind interface for this lightweight HTTP server
# - UPSTREAM_TIMEOUT (optional): request timeout in seconds


def _load_upstreams() -> List[str]:
    raw = os.environ.get("servers", "").strip()
    if not raw:
        raise RuntimeError(
            "Environment variable 'servers' must list upstream endpoints"
        )

    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        parsed = None

    if isinstance(parsed, str):
        return [parsed]
    if isinstance(parsed, list):
        return [str(item).strip() for item in parsed if str(item).strip()]

    return [segment.strip() for segment in raw.split(",") if segment.strip()]


UPSTREAMS = _load_upstreams()
TIMEOUT_SECONDS = float(os.environ.get("UPSTREAM_TIMEOUT", "5"))


def _forward_verify(url: str, payload: Dict) -> Tuple[bool, str]:
    """POST payload to upstream verify endpoint and return allow flag plus note."""
    data = json.dumps(payload).encode()
    request = Request(
        url=url, data=data, headers={"Content-Type": "application/json"}, method="POST"
    )
    try:
        with urlopen(request, timeout=TIMEOUT_SECONDS) as response:
            body = response.read().decode()
    except HTTPError as exc:
        return False, f"{url} -> HTTP {exc.code}"
    except URLError as exc:
        return False, f"{url} -> {exc.reason}"

    try:
        parsed = json.loads(body)
    except json.JSONDecodeError:
        return False, f"{url} -> invalid JSON"

    allow_value = parsed.get("Allow")
    if isinstance(allow_value, bool) and allow_value:
        return True, "Allow=True"
    return False, f"{url} -> Allow={allow_value}"


class VerifyHandler(BaseHTTPRequestHandler):
    def _json_response(self, body: Dict, status: int = 200):
        payload = json.dumps(body).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)

    def do_POST(self):  # noqa: N802 (BaseHTTPRequestHandler requirement)
        if self.path != "/verify":
            self._json_response({"error": "Not Found"}, status=404)
            return

        length = int(self.headers.get("Content-Length", "0"))
        if length <= 0:
            self._json_response({"error": "Missing body"}, status=400)
            return

        try:
            body = self.rfile.read(length).decode()
            payload = json.loads(body)
        except (UnicodeDecodeError, json.JSONDecodeError):
            self._json_response({"error": "Invalid JSON"}, status=400)
            return

        results = []
        for upstream in UPSTREAMS:
            allowed, note = _forward_verify(upstream, payload)
            results.append(note)
            if allowed:
                self._json_response({"Allow": True, "details": results})
                return

        self._json_response({"Allow": False, "details": results})


def main():
    host = os.environ.get("HOST", "0.0.0.0")
    port = int(os.environ.get("PORT", "8080"))
    server = HTTPServer((host, port), VerifyHandler)
    logging.info("Starting derper verify proxy on %s:%s", host, port)
    logging.info("Configured upstreams: %s", ", ".join(UPSTREAMS))
    server.serve_forever()


if __name__ == "__main__":
    main()
