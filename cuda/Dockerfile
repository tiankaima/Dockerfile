ARG CUDA_BASE=12.4.1-cudnn-devel-ubuntu22.04
FROM nvidia/cuda:${CUDA_BASE}

COPY setup.sh /tmp/setup.sh
RUN bash /tmp/setup.sh \
    && rm /tmp/setup.sh

USER user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \    
    git clone https://github.com/marlonrichert/zsh-autocomplete.git /home/user/.oh-my-zsh/custom/plugins/zsh-autocomplete && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/user/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/user/.oh-my-zsh/custom/plugins/zsh-autosuggestions

COPY src /home/user