# Stage 1: Build
FROM golang:1.23-alpine AS builder

# Install required build tools
RUN apk add --no-cache build-base

# Set the working directory
WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the application source code
COPY . .

# Build the Go binary statically
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o goapp .

# Create a non-root user and group 
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Stage 2: Runtime
FROM gcr.io/distroless/static:nonroot

# Set working directory
WORKDIR /app

# Copy the compiled binary from the builder
COPY --from=builder /app/goapp .
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Switch to the non-root user 
USER appuser

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["./goapp"]