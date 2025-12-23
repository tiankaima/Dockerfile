FROM ubuntu:24.04

ARG MINIFORGE_NAME=Miniforge3
ARG MINIFORGE_VERSION=25.11.0-0
ARG TARGETPLATFORM
ARG USERNAME=user
ARG USER_UID=1000

ENV CONDA_DIR=/opt/conda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=${CONDA_DIR}/bin:${PATH}
ENV DEBIAN_FRONTEND=noninteractive

COPY src /home/user

RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update > /dev/null && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends --yes \
    wget bzip2 ca-certificates git tini curl sudo neovim tmux less ssh ncdu tree \
    > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget --no-hsts --quiet https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh -O /tmp/miniforge.sh && \
    /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge.sh && \
    conda clean --tarballs --index-cache --packages --yes && \
    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
    conda clean --force-pkgs-dirs --all --yes  && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /etc/skel/.bashrc && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /home/${USERNAME}/.bashrc && \
    userdel -rf ubuntu || true && \
    useradd -m ${USERNAME} --uid=${USER_UID} && \
    usermod -aG sudo ${USERNAME} && \
    echo "user:password" | chpasswd && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/${USERNAME} && \
    chsh -s /bin/bash ${USERNAME} && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} && \
    chown -R ${USERNAME}:${USERNAME} ${CONDA_DIR}

USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENTRYPOINT ["tini", "--"]
CMD [ "/bin/bash" ]