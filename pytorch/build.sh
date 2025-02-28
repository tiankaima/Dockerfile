#!/bin/bash
set -e

TAGS=(
  24.12-py3
  22.12-py3
)
``
for tag in "${TAGS[@]}"; do
  docker pull ghcr.io/${OWNER}/pytorch-${tag} || true

  docker build --cache-from ghcr.io/${OWNER}/pytorch-${tag} \
    -t ghcr.io/${OWNER}/pytorch-${tag}:latest \
    --build-arg VER=${tag} \
    ./pytorch

  docker push ghcr.io/${OWNER}/pytorch-${tag}:latest

  docker image rm ghcr.io/${OWNER}/pytorch-${tag}:latest
  docker system prune -f
done
