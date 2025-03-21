#!/bin/bash
set -e

TAGS=(
  24.12-py3
)

for tag in "${TAGS[@]}"; do
  docker pull ghcr.io/${OWNER}/pytorch-${tag} || true

  docker build -t ghcr.io/${OWNER}/pytorch:${tag} \
    --build-arg VER=${tag} \
    ./pytorch

  docker push ghcr.io/${OWNER}/pytorch:${tag}

  docker image rm ghcr.io/${OWNER}/pytorch:${tag}
  docker system prune -f
done
