FROM jenkins/jenkins:lts

USER root
# Install needed tools
RUN apt-get update && apt-get install -y \
    curl \
    dnsutils \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Switch back to jenkins user
USER jenkins


