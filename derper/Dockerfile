FROM golang:latest
WORKDIR /app

ARG DERP_VERSION=latest
RUN go install tailscale.com/cmd/derper@${DERP_VERSION}

CMD [ "/go/bin/derper" ]