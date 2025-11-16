FROM python:3.11-slim

# Install system dependencies for Playwright
RUN apt-get update && apt-get install -y \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libgbm1 \
    libglib2.0-0 \
    libnspr4 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libxkbcommon0 \
    libasound2t64 \
    && rm -rf /var/lib/apt/lists/*

# Install shot-scraper
RUN pip install shot-scraper

# Install the browser and system dependencies
RUN shot-scraper install
RUN playwright install-deps

# Create a working directory
WORKDIR /screenshots

# Default command
CMD ["shot-scraper", "--help"]
