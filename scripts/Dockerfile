FROM ubuntu:24.10

workdir /app

# Install any needed packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    sudo \
    hostnamectl \
    && rm -rf /var/lib/apt/lists/*

COPY ./setup.sh .
COPY ./master_node_setup.sh .

ENTRYPOINT ["bash", "./setup.sh"]
