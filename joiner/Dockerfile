FROM debian:buster-20201209-slim

ENV SERF_VERSION "0.8.2"
ENV SERF_URL "https://releases.hashicorp.com/serf/0.8.2/serf_0.8.2_linux_amd64.zip"
ENV SERF_SHA256SUM "1977efc7ed44749e1ae6a0f9b4efca3024932187d83eb61de00ba19fd8146596"

# Download and extract serf to run as a client
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        telnet \
        netcat \
        unzip; \
    curl --silent --output /tmp/serf.zip $SERF_URL; \
    echo "$SERF_SHA256SUM /tmp/serf.zip" | sha256sum -c -; \
    unzip /tmp/serf.zip -d /usr/local/bin; \
    rm /tmp/serf.zip; \
    apt-get remove -y ca-certificates curl unzip; \
    rm -rf /var/lib/apt/lists/*; \
    echo "serf downloaded and extracted";

COPY joiner/run-joiner.sh /usr/local/bin

# Configure user
RUN set -eux; \
    useradd -ms /bin/bash nonroot; \
    chmod +x /usr/local/bin/run-joiner.sh
USER nonroot

# Run the joiner script
CMD ["/usr/local/bin/run-joiner.sh"]
