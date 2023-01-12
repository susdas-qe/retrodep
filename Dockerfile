# Build the manager binary
FROM registry.access.redhat.com/ubi8/go-toolset:1.17 as builder

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

# Copy the go source
COPY main.go main.go
COPY retrodep/ retrodep/

# Build
RUN if [ -e "/cachi2/cachi2.env" ]; then source "/cachi2/cachi2.env"; fi && go build -o retrodep-bin ./main.go

# Use ubi-minimal as minimal base image to package the manager binary
# Refer to https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8 for more details
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6-751
COPY --from=builder /opt/app-root/src/retrodep-bin /

ENTRYPOINT ["/retrodep-bin"]
