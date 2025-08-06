#!/bin/bash

# Start STF DeviceFarm script
# This script starts the complete STF DeviceFarm environment

set -e

echo "🚀 Starting STF DeviceFarm..."

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

# Check if stf-devicefarm image exists
if ! docker images | grep -q "stf-devicefarm"; then
    echo "⚠️  Warning: stf-devicefarm image not found."
    echo "Building the image first..."
    ./build-devicefarm.sh
fi

# Create network if it doesn't exist
if ! docker network ls | grep -q "stf-network"; then
    echo "📡 Creating stf-network..."
    docker network create stf-network
fi

# Start the services
echo "🔄 Starting STF DeviceFarm services..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service status
echo "📊 Checking service status..."
$COMPOSE_CMD -f docker-compose-prod.yaml ps

echo ""
echo "✅ STF DeviceFarm is starting up!"
echo ""
echo "🌐 Access the application at:"
echo "   http://localhost"
echo ""
echo "📱 STF App: http://localhost:3100"
echo "🔐 STF Auth: http://localhost:3200"
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