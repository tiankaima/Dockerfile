ARG VER=24.12-py3
FROM nvcr.io/nvidia/pytorch:${VER}

COPY setup.sh /tmp/setup.sh
RUN bash /tmp/setup.sh \
    && rm /tmp/setup.sh

COPY src /home/user
RUN sudo chown -R user:user /home/user