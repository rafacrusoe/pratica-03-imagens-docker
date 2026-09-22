FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends iputils-ping && \
    rm -rf /var/lib/apt/lists/*

CMD ["ping", "-w", "5", "google.com"]

