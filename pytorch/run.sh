#!/bin/bash
set -e

if [ ! -d "data" ]; then
  mkdir data
fi

if [ ! -d "data-conda" ]; then
  mkdir data-conda
fi

if [ ! -z "$DEBUG" ]; then
  echo "DEBUG mode"
  docker build \
    -t ghcr.io/tiankaima/pytorch:latest \
    .
fi

docker run \
  -it --rm --name cuda \
  -h cuda \
  -v $(pwd)/data:/mnt \
  -v /opt/miniconda3/pkgs:/opt/miniconda3/pkgs \
  --runtime=nvidia --gpus=all \
  ghcr.io/tiankaima/pytorch:latest
