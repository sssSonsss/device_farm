#!/bin/bash

# Start STF DeviceFarm services in correct order based on DEPLOYMENT.md
# This script ensures services start in the proper sequence

set -e

echo "🚀 Starting STF DeviceFarm in correct order..."

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

# Create network if it doesn't exist
if ! docker network ls | grep -q "stf-network"; then
    echo "📡 Creating stf-network..."
    docker network create stf-network
fi

# Step 1: Start Database Layer
echo "📊 Step 1: Starting Database Layer..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d rethinkdb

echo "⏳ Waiting for RethinkDB to be healthy..."
sleep 10
until docker compose -f docker-compose-prod.yaml ps rethinkdb | grep -q "healthy"; do
    echo "Waiting for RethinkDB health check..."
    sleep 5
done
echo "✅ RethinkDB is healthy"

# Step 2: Start ADB Service
echo "📱 Step 2: Starting ADB Service..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d adb
sleep 5

# Step 3: Start Triproxy Services
echo "🔗 Step 3: Starting Triproxy Services..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d stf-triproxy-app stf-triproxy-dev
sleep 5

# Step 4: Start Storage Services
echo "💾 Step 4: Starting Storage Services..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d stf-storage-apk stf-storage-image stf-storage-temp
sleep 5

# Step 5: Start Authentication Service
echo "🔐 Step 5: Starting Authentication Service..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d stf-auth

echo "⏳ Waiting for Auth service to be healthy..."
sleep 10
until docker compose -f docker-compose-prod.yaml ps stf-auth | grep -q "healthy"; do
    echo "Waiting for Auth service health check..."
    sleep 5
done
echo "✅ Auth service is healthy"

# Step 6: Start Main App Service
echo "🌐 Step 6: Starting Main App Service..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d stf-app

echo "⏳ Waiting for App service to be healthy..."
sleep 10
until docker compose -f docker-compose-prod.yaml ps stf-app | grep -q "healthy"; do
    echo "Waiting for App service health check..."
    sleep 5
done
echo "✅ App service is healthy"

# Step 7: Start WebSocket Service
echo "🔌 Step 7: Starting WebSocket Service..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d stf-websocket
sleep 5

# Step 8: Start API Service
echo "📡 Step 8: Starting API Service..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d stf-api
sleep 5

# Step 9: Start Provider Service
echo "📱 Step 9: Starting Provider Service..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d stf-provider
sleep 5

# Step 10: Start Nginx Proxy
echo "🌐 Step 10: Starting Nginx Proxy..."
$COMPOSE_CMD -f docker-compose-prod.yaml up -d nginx

# Wait for all services to be ready
echo "⏳ Waiting for all services to be ready..."
sleep 15

# Check service status
echo "📊 Checking service status..."
$COMPOSE_CMD -f docker-compose-prod.yaml ps

echo ""
echo "✅ STF DeviceFarm started successfully in correct order!"
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