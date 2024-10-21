#!/bin/bash
set -e

docker pull ghcr.io/${OWNER}/cuda:latest || true
docker pull ghcr.io/${OWNER}/cuda-11.6/latest || true

docker build --cache-from ghcr.io/${OWNER}/cuda:latest \
  -t ghcr.io/${OWNER}/cuda:${SHA} \
  -t ghcr.io/${OWNER}/cuda:latest \
  --build-arg USERNAME=${OWNER} \
  ./cuda

docker build --cache-from ghcr.io/${OWNER}/cuda-11.6:latest \
  -t ghcr.io/${OWNER}/cuda-11.6:${SHA} \
  -t ghcr.io/${OWNER}/cuda-11.6:latest \
  --build-arg USERNAME=${OWNER} \
  --build-arg CUDA_BASE=11.6.1-devel-ubuntu20.04 \
  ./cuda

docker push ghcr.io/${OWNER}/cuda:${SHA}
docker push ghcr.io/${OWNER}/cuda:latest
docker push ghcr.io/${OWNER}/cuda-11.6:${SHA}
docker push ghcr.io/${OWNER}/cuda-11.6:latest
