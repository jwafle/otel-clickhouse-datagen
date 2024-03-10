# Use Alpine Linux for its minimal size
FROM alpine:latest as builder

# Install necessary dependencies
RUN apk update && apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*

# otlp endpoint
EXPOSE 8088/tcp

# health_check endpoint
EXPOSE 13133/tcp

# prometheus endpoint for internal metrics
EXPOSE 8888/tcp

# Copy the custom OpenTelemetry Collector binary
COPY ./generated/otel-clickhouse-datagen /otel-clickhouse-datagen

# Copy the telemetry-generator config
COPY generator-config.yml /etc/generator-config.yml
# Set the env variable for generatorreceiver according to: https://github.com/lightstep/telemetry-generator?tab=readme-ov-file#topo-file-generatorreceiver-config
ENV TOPO_FILE=/etc/generator-config.yml

# Copy the collector configuration file
COPY config.yml /etc/config.yml

# Set the entry point and default command
ENTRYPOINT ["/otel-clickhouse-datagen"]
CMD ["--config", "etc/config.yml"]