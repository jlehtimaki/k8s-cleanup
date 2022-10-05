FROM alpine:3.16 AS builder
RUN apk add curl
WORKDIR binary
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl

FROM alpine:3.16

WORKDIR app

RUN apk add jq

COPY --from=builder /binary/kubectl /usr/bin/kubectl
COPY clean-up.sh .

ENTRYPOINT ["sh","clean-up.sh"]