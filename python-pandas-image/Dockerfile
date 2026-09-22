FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3.10 python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN python3.10 -m pip install --no-cache-dir pandas

WORKDIR /app

COPY script.py /app/script.py

CMD ["python3.10", "/app/script.py"]

