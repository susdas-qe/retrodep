# Build the manager binary
FROM registry.access.redhat.com/ubi8/go-toolset:1.21 as builder

# Check if the build is performed in hermetic environment
# (without access to the internet)
RUN if curl -s example.com > /dev/null; then echo "build is not being performed in hermetic environment" && exit 1; fi

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

# Copy the go source
COPY main.go main.go
COPY retrodep/ retrodep/

# Build
RUN go build -o retrodep-bin ./main.go

# Use ubi-minimal as minimal base image to package the manager binary
# Refer to https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8 for more details
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6-751
COPY --from=builder /opt/app-root/src/retrodep-bin /

ENTRYPOINT ["/retrodep-bin"]
