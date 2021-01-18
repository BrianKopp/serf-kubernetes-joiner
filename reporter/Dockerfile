FROM python:3.9.1-slim-buster

ENV AWS_CLI_VERSION "2.1.19"
ENV AWS_CLI_URL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.1.19.zip"
ENV AWS_CLI_SHA256SUM "36fd8cb2ca82bfec27a25d23643de4879a9da88be7c44f5e0628d4fe159e8c2f"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        unzip; \
    cd /tmp; \
    curl $AWS_CLI_URL -o "awscliv2.zip"; \
    echo "$AWS_CLI_SHA256SUM /tmp/awscliv2.zip" | sha256sum -c -; \
    unzip awscliv2.zip; \
    rm awscliv2.zip; \
    cd aws; \
    ./install; \
    aws --version; \
    rm -rf aws; \
    apt-get remove -y ca-certificates curl unzip; \
    rm -rf /var/lib/apt/lists/*;

COPY reporter/run-reporter.sh /usr/local/bin

# Configure user
RUN set -eux; \
    useradd -ms /bin/bash nonroot; \
    chmod +x /usr/local/bin/run-reporter.sh
USER nonroot

CMD ["/usr/local/bin/run-reporter.sh"]
