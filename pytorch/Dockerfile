ARG PYTORCH_BASE=2.9.1-cuda12.6-cudnn9-runtime
FROM pytorch/pytorch:${PYTORCH_BASE}

COPY setup.sh /tmp/setup.sh
COPY src /home/user
RUN bash /tmp/setup.sh \
    && rm /tmp/setup.sh

USER user
WORKDIR /home/user
CMD ["bash"]