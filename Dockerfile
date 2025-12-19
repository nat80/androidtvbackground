FROM python:3.13-slim

# Install compilation dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    procps \
    libopenjp2-7 \
    libtiff6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Environment variable to indicate we are in Docker
ENV DOCKER_CONTAINER=1

# Copy all project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Supercronic version
ENV SUPERCRONIC_VERSION=0.2.41

RUN curl -fsSLO https://github.com/aptible/supercronic/releases/download/v${SUPERCRONIC_VERSION}/supercronic-linux-arm64 \
    && chmod +x supercronic-linux-arm64 \
    && mv supercronic-linux-arm64 /usr/local/bin/supercronic \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Run supercronic
CMD ["supercronic", "crontab.txt"]
