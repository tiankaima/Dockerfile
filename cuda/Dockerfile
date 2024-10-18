FROM nvidia/cuda:12.6.2-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
    curl wget git sudo \
    neovim zsh tmux \
    && rm -rf /var/lib/apt/lists/*

# setup miniconda:
ARG MINICONDA_PATH=/opt/miniconda3
ARG MINICONDA_VERSION=latest

RUN curl -s -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
    && bash miniconda.sh -b -p ${MINICONDA_PATH} \
    && rm miniconda.sh

ENV PATH=${MINICONDA_PATH}/bin:${PATH}

# setup user:
ARG USERNAME=user
ARG USER_UID=1000

RUN useradd -m ${USERNAME} --uid=${USER_UID} \
    && usermod -aG sudo ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENTRYPOINT ["/bin/zsh"]
