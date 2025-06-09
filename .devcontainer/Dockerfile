# Use the modern Ubuntu LTS image from Microsoft as a stable base.
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Set non-interactive frontend to prevent installers from prompting for user input during build.
ENV DEBIAN_FRONTEND=noninteractive

# Install core dependencies and TFLint for code quality analysis.
# The architecture is detected dynamically to ensure portability between arm64 (Mac M1/M2) and amd64 (Intel/Windows).
RUN apt-get update && apt-get -y install --no-install-recommends curl ca-certificates gnupg software-properties-common wget unzip \
    && ARCH=$(dpkg --print-architecture) \
    && curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest \
    | grep "browser_download_url.*_linux_${ARCH}.zip" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi - \
    && unzip "tflint_linux_${ARCH}.zip" \
    && rm "tflint_linux_${ARCH}.zip" \
    && mv tflint /usr/local/bin/

# Install Terraform using the official HashiCorp APT repository and the modern GPG key method.
# This approach is multi-architecture by default.
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y terraform

# Install the Google Cloud CLI.
RUN curl -fsS https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get update && apt-get install -y google-cloud-cli

# Install the GitHub CLI for repository and PR management from the terminal.
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh

# Clean up apt cache to reduce final image size.
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
