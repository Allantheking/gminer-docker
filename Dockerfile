FROM nvidia/cuda:12.4.1-base-ubuntu22.04 as nvidia

ENV DEBIAN_FRONTEND=noninteractive
ARG GMINER_VERSION=3.44
ARG GMINER2_VERSION=3_44

RUN apt-get update && \
    apt-get install -y wget tar curl libcurl4 && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/develsoftware/GMinerRelease/releases/download/${GMINER_VERSION}/gminer_${GMINER2_VERSION}_linux64.tar.xz -O /tmp/gminer.tar.xz && \
    mkdir -p /opt/gminer && \
    tar --strip-components=1 -xvf /tmp/gminer.tar.xz -C /opt/gminer && \
    rm /tmp/gminer.tar.xz

# Make the rigel binary executable
RUN chmod +x /opt/gminer/gminer

# Copy the entrypoint script into the image
COPY entrypoint.sh /opt/gminer/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /opt/gminer/entrypoint.sh

# Set working directory
WORKDIR /opt/gminer

# Define environment variables with default values
ENV ALGO=""
ENV POOL=""
ENV WALLET=""
ENV EXTRA=""

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/opt/gminer/entrypoint.sh"]
