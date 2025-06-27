# `tiankaima/caddy-cf`

Caddy with the following plugins enabled:

- cloudflare
- replace-response
- caddy-webdav

## Usage

```bash
docker run -d --name caddy-cf \
    -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile \
    -v $(pwd)/html:/srv/www/html \
    -p 80:80 -p 443:443 \
    tiankaima/caddy-cf
```