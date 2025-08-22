# =====================
# Stage 1: Builder
# =====================
FROM python:3.11-slim AS builder

WORKDIR /app

# Install system dependencies required by pygame
RUN apt-get update && apt-get install -y \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python deps
COPY requirements.txt .
RUN pip install --user -r requirements.txt


# =====================
# Stage 2: Final runtime
# =====================
FROM python:3.11-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Copy your game code
COPY src/ /app/

# Run the game
CMD ["python", "dino.py"]
