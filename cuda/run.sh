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
    --build-arg USERID=$(id -u) \
    --build-arg USERNAME=$(whoami) \
    -t ghcr.io/tiankaima/cuda:latest \
    .

  docker run \
    -it --rm --name cuda \
    -h cuda \
    -v $(pwd)/data:/home/$(whoami) \
    -v /opt/miniconda3:/opt/miniconda3 \
    --runtime=nvidia --gpus=all \
    ghcr.io/tiankaima/cuda:latest
else
  docker run \
    -it --rm --name cuda \
    -h cuda \
    -v $(pwd)/data:/home/tiankaima \
    -v /opt/miniconda3/:/opt/miniconda3 \
    --runtime=nvidia --gpus=all \
    ghcr.io/tiankaima/cuda:latest
fi
