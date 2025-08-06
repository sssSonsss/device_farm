#!/bin/bash

# Check Docker and Docker Compose availability
echo "🔍 Checking Docker and Docker Compose..."

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is installed and running"

# Check Docker Compose
if command -v docker-compose &> /dev/null; then
    echo "✅ docker-compose (legacy) is available"
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    echo "✅ docker compose (new) is available"
    COMPOSE_CMD="docker compose"
else
    echo "❌ Neither docker-compose nor docker compose is available"
    echo "Please install Docker Compose or update Docker to a version that includes Compose"
    exit 1
fi

echo ""
echo "🚀 Ready to use STF DeviceFarm!"
echo "Using command: $COMPOSE_CMD"
echo ""
echo "To start services:"
echo "  $COMPOSE_CMD -f docker-compose-prod.yaml up -d"
echo ""
echo "To view logs:"
echo "  $COMPOSE_CMD -f docker-compose-prod.yaml logs -f"
echo ""
echo "To stop services:"
echo "  $COMPOSE_CMD -f docker-compose-prod.yaml down" 