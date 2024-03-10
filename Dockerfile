# Use Alpine Linux for its minimal size
FROM alpine:latest as builder

# Install necessary dependencies
RUN apk update && apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*

# Copy the custom OpenTelemetry Collector binary
COPY otelcol-datagen /otelcol-datagen

# Copy the collector configuration file
COPY config.yaml /etc/config.yaml

# Set the entry point and default command
ENTRYPOINT ["/otelcol-datagen"]
CMD ["--config", "/etc/config.yaml"]
