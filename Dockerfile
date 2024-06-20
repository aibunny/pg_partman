FROM postgres:latest

LABEL maintainer="aibunny"


# Install required packages
RUN apt-get update -y && apt-get install -y \
    wget build-essential git \
    curl ca-certificates \
    pkg-config libssl-dev \
    ca-certificates tzdata libxml2 \
    libssh2-1 

# Install TRUNK PSQL extension library
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && export PATH="/root/.cargo/bin:${PATH}" \
    && cargo install pg-trunk \
    && trunk install pgvector \
    && trunk install pg_partman \
    && rm -rf /root/.cargo /root/.rustup

  
# Clean up temporary files and dependencies
RUN apt-get purge -y git build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


# Copy custom configuration files

# Healthcheck
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
    CMD pg_isready

# Expose the PostgreSQL port
EXPOSE 5432

USER postgres
# Start PostgreSQL with custom configuration
CMD ["postgres"]

