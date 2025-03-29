#!/bin/bash
set -e

TAGS=(
  12.4.1-cudnn-runtime-ubuntu22.04
  12.4.1-cudnn-runtime-ubuntu20.04
  12.1.1-cudnn8-runtime-ubuntu22.04
  12.1.1-cudnn8-runtime-ubuntu20.04
  11.8.0-cudnn8-runtime-ubuntu22.04
  11.8.0-cudnn8-runtime-ubuntu20.04
)

for tag in "${TAGS[@]}"; do
  docker pull ghcr.io/${OWNER}/cuda:${tag} || true

  docker build -t ghcr.io/${OWNER}/cuda:${tag} \
    --build-arg CUDA_BASE=${tag} \
    ./cuda

  docker push ghcr.io/${OWNER}/cuda:${tag}

  docker image rm ghcr.io/${OWNER}/cuda:${tag}
  docker system prune -f
done
