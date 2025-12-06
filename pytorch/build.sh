#!/bin/bash
set -xeuo pipefail

TAGS=(
  2.9.1-cuda12.6-cudnn9-runtime
  2.9.1-cuda12.8-cudnn9-runtime
  2.9.1-cuda13.0-cudnn9-runtime
  2.6.0-cuda12.4-cudnn9-runtime
)

for tag in "${TAGS[@]}"; do
  docker pull ${OWNER}/pytorch:${tag} || true

  docker build \
    -t ${OWNER}/pytorch:${tag} \
    --build-arg PYTORCH_BASE=${tag} \
    ./pytorch

  docker push ${OWNER}/pytorch:${tag}
  docker image rm ${OWNER}/pytorch:${tag}
  docker system prune -f
done
