FROM bitnami/aws-cli:1.18.216-debian-10-r1

COPY reporter/run-reporter.sh /usr/local/bin

# Configure user
RUN set -eux; \
    useradd -ms /bin/bash nonroot; \
    chmod +x /usr/local/bin/run-reporter.sh
USER nonroot

CMD ["/usr/local/bin/run-reporter.sh"]
