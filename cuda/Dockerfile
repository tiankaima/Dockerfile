ARG CUDA_BASE=12.4.1-cudnn-devel-ubuntu22.04
FROM nvidia/cuda:${CUDA_BASE}

COPY setup.sh /tmp/setup.sh
RUN bash /tmp/setup.sh \
    && rm /tmp/setup.sh

COPY src /home/user
RUN sudo chown -R user:user /home/user
