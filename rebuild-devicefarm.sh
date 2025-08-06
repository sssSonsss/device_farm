#!/bin/bash

# Rebuild and restart STF DeviceFarm with new configuration
# This script rebuilds the image and restarts services with updated config

set -e

echo "🔄 Rebuilding STF DeviceFarm with new configuration..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Determine Docker Compose command
if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Error: Neither docker-compose nor docker compose is available"
    echo "Please install Docker Compose or update Docker to a version that includes Compose"
    exit 1
fi

echo "Using Docker Compose command: $COMPOSE_CMD"

# Stop existing services
echo "🛑 Stopping existing services..."
$COMPOSE_CMD -f docker-compose-prod.yaml down 2>/dev/null || true

# Remove old image
echo "🗑️  Removing old stf-devicefarm image..."
docker rmi stf-devicefarm:latest 2>/dev/null || true

# Build new image
echo "🔨 Building new stf-devicefarm image..."
docker build -f Dockerfile-devicefarm -t stf-devicefarm:latest .

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Successfully built stf-devicefarm:latest"
else
    echo "❌ Failed to build stf-devicefarm:latest"
    exit 1
fi

# Create network if it doesn't exist
if ! docker network ls | grep -q "stf-network"; then
    echo "📡 Creating stf-network..."
    docker network create stf-network
fi

# Start services with new configuration
echo "🚀 Starting services with new configuration..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 15

# Check service status
echo "📊 Checking service status..."
$COMPOSE_CMD -f docker-compose-prod.yaml ps

echo ""
echo "✅ STF DeviceFarm has been rebuilt and restarted!"
echo ""
echo "🌐 Access the application at:"
echo "   http://localhost"
echo ""
echo "📱 STF App: http://localhost:7105"
echo "🔐 STF Auth: http://localhost:7120"
echo "📡 STF API: http://localhost:3700"
echo "🔌 STF WebSocket: ws://localhost:3600"
echo ""
echo "📋 Useful commands:"
echo "   View logs: $COMPOSE_CMD -f docker-compose-prod.yaml logs -f"
echo "   Stop services: $COMPOSE_CMD -f docker-compose-prod.yaml down"
echo "   Restart services: $COMPOSE_CMD -f docker-compose-prod.yaml restart"
echo ""
echo "🔍 To check if all services are healthy:"
echo "   $COMPOSE_CMD -f docker-compose-prod.yaml ps" 