ARG VER=24.12-py3

FROM nvcr.io/nvidia/pytorch:${VER}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
    curl wget git sudo \
    neovim tmux less \
    ssh \
    && rm -rf /var/lib/apt/lists/*

ARG MINICONDA_PATH=/opt/miniconda3
ARG MINICONDA_VERSION=latest

RUN curl -s -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
    && bash miniconda.sh -b -p ${MINICONDA_PATH} \
    && rm miniconda.sh

ARG USERNAME=user
ARG USER_UID=1000

RUN useradd -m ${USERNAME} --uid=${USER_UID} \
    && usermod -aG sudo ${USERNAME} \
    && echo 'user:password' | chpasswd \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} \
    && sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && chown -R ${USERNAME}:${USERNAME} ${MINICONDA_PATH} \
    && chsh -s /bin/bash ${USERNAME} \
    && service ssh start

USER ${USERNAME}
WORKDIR /home/${USERNAME}
COPY src /home/${USERNAME}

RUN sudo chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} \
    && mkdir -p /home/${USERNAME}/.cache \
    && sudo cp -rT /home/${USERNAME} /etc/skel

EXPOSE 22
CMD ["sudo", "/usr/sbin/sshd", "-D"]
