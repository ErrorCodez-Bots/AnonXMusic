FROM python:3.13-slim

WORKDIR /app

# 1. Install FFmpeg, curl, unzip, and other dependencies
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends ffmpeg curl unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Deno using the correct official URL
RUN curl -fsSL https://deno.land/x/install/install.sh | sh

# 3. Set the Environment Path for Deno
ENV DENO_INSTALL="/root/.deno"
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

# 4. Install UV (Python Package Manager)
RUN curl -Ls https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# 5. Sync Python libraries
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen

# 6. Copy all remaining files
COPY . .

# 7. Grant execution permissions to the start script and run the application
RUN chmod +x start
CMD ["./start"]
