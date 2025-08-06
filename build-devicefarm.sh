#!/bin/bash

# Build script for STF DeviceFarm Docker image
# This script builds the stf-devicefarm image using the Dockerfile-devicefarm

set -e

echo "Building STF DeviceFarm Docker image..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Build the image
echo "Building stf-devicefarm:latest..."
docker build -f Dockerfile-devicefarm -t stf-devicefarm:latest .

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Successfully built stf-devicefarm:latest"
    echo ""
    echo "You can now use the image in your Docker Compose files:"
    echo "  image: stf-devicefarm:latest"
    echo ""
    echo "To run the services:"
    echo "  docker-compose -f docker-compose-prod.yaml up -d"
    echo ""
    echo "To see the built image:"
    echo "  docker images | grep stf-devicefarm"
else
    echo "❌ Failed to build stf-devicefarm:latest"
    exit 1
fi 