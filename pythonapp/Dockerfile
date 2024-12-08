# Stage 1: Builder stage for dependencies
FROM python:3.11-slim AS builder

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Stage 2: Final image
FROM python:3.11-slim

# Set work directory
WORKDIR /app

# Copy only the necessary files
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY . .

# Set a non-root user
USER 1000

# Expose the application port
EXPOSE 8090

# Run the application
CMD ["python", "main.py"]