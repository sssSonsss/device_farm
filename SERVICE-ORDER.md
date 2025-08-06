# STF DeviceFarm Service Startup Order

## Overview
Based on the `DEPLOYMENT.md` documentation, services must be started in a specific order to ensure proper dependencies and communication. This document outlines the correct startup sequence.

## Service Startup Order

### 1. Database Layer (First Priority)
**Service:** `rethinkdb`
- **Purpose:** Core database for STF
- **Dependencies:** None
- **Health Check:** Required before other services start
- **Port:** 28015 (internal), 8080 (admin)

### 2. ADB Service (Device Connection)
**Service:** `adb`
- **Purpose:** Android Debug Bridge for device communication
- **Dependencies:** None
- **Port:** 5037

### 3. Triproxy Services (Communication Bridges)
**Services:** `stf-triproxy-app`, `stf-triproxy-dev`
- **Purpose:** ZeroMQ communication bridges
- **Dependencies:** None
- **Network Mode:** Host (for direct port binding)
- **Ports:** 7150-7170 (app), 7250-7270 (dev)

### 4. Storage Services (Data Management)
**Services:** `stf-storage-apk`, `stf-storage-image`, `stf-storage-temp`
- **Purpose:** Handle APK files, images, and temporary storage
- **Dependencies:** None (but need app service URL)
- **Ports:** 3300, 3400, 3500

### 5. Authentication Service
**Service:** `stf-auth`
- **Purpose:** User authentication and session management
- **Dependencies:** RethinkDB (healthy)
- **Port:** 7120
- **Health Check:** Required before app service

### 6. Main App Service
**Service:** `stf-app`
- **Purpose:** Main web interface and static resources
- **Dependencies:** RethinkDB (healthy), Auth service (healthy)
- **Port:** 7105
- **Health Check:** Required before websocket service

### 7. WebSocket Service
**Service:** `stf-websocket`
- **Purpose:** Real-time communication layer
- **Dependencies:** RethinkDB (healthy), App service (healthy)
- **Port:** 3600

### 8. API Service
**Service:** `stf-api`
- **Purpose:** RESTful APIs for STF
- **Dependencies:** RethinkDB (healthy)
- **Port:** 3700

### 9. Provider Service (Last Core Service)
**Service:** `stf-provider`
- **Purpose:** Device management and control
- **Dependencies:** ADB service, RethinkDB (healthy)
- **Ports:** 15000-15100 (device ports)

### 10. Nginx Proxy (Final Service)
**Service:** `nginx`
- **Purpose:** Reverse proxy and load balancer
- **Dependencies:** All other services (healthy)
- **Ports:** 80, 443

## Dependencies Summary

```
rethinkdb (healthy)
    ↓
adb
    ↓
stf-triproxy-app, stf-triproxy-dev
    ↓
stf-storage-* (parallel)
    ↓
stf-auth (healthy)
    ↓
stf-app (healthy)
    ↓
stf-websocket
    ↓
stf-api (parallel)
    ↓
stf-provider
    ↓
nginx
```

## Health Check Requirements

### Services with Health Checks:
1. **rethinkdb** - Must be healthy before auth, app, websocket, api, provider
2. **stf-auth** - Must be healthy before app
3. **stf-app** - Must be healthy before websocket
4. **stf-api** - Health check for monitoring
5. **stf-websocket** - Health check for monitoring

### Services without Health Checks:
- adb (no health check needed)
- stf-triproxy-* (no health check needed)
- stf-storage-* (no health check needed)
- stf-provider (no health check needed)
- nginx (depends on other services)

## Startup Scripts

### Quick Start (All at once):
```bash
./start-devicefarm.sh
```

### Ordered Start (Step by step):
```bash
./start-ordered.sh
```

### Manual Start:
```bash
# 1. Create network
docker network create stf-network

# 2. Start in order
docker compose -f docker-compose-prod.yaml up -d rethinkdb
# Wait for healthy
docker compose -f docker-compose-prod.yaml up -d adb
docker compose -f docker-compose-prod.yaml up -d stf-triproxy-app stf-triproxy-dev
docker compose -f docker-compose-prod.yaml up -d stf-storage-apk stf-storage-image stf-storage-temp
docker compose -f docker-compose-prod.yaml up -d stf-auth
# Wait for healthy
docker compose -f docker-compose-prod.yaml up -d stf-app
# Wait for healthy
docker compose -f docker-compose-prod.yaml up -d stf-websocket
docker compose -f docker-compose-prod.yaml up -d stf-api
docker compose -f docker-compose-prod.yaml up -d stf-provider
docker compose -f docker-compose-prod.yaml up -d nginx
```

## Troubleshooting

### Common Issues:
1. **Database Connection Errors**: Ensure rethinkdb is healthy before starting other services
2. **Auth Service Errors**: Check database connection and port configuration
3. **App Service Errors**: Verify auth service is healthy and accessible
4. **WebSocket Errors**: Ensure app service is healthy
5. **Provider Errors**: Check ADB service and database connection

### Debug Commands:
```bash
# Check service status
docker compose -f docker-compose-prod.yaml ps

# View logs for specific service
docker compose -f docker-compose-prod.yaml logs -f stf-auth

# Check health status
docker compose -f docker-compose-prod.yaml ps | grep healthy

# Restart specific service
docker compose -f docker-compose-prod.yaml restart stf-auth
```

## Port Configuration

| Service | Internal Port | External Port | Purpose |
|---------|---------------|---------------|---------|
| rethinkdb | 28015 | 28015 | Database |
| adb | 5037 | 5037 | Device connection |
| stf-auth | 7120 | 7120 | Authentication |
| stf-app | 7105 | 7105 | Main web interface |
| stf-websocket | 3000 | 3600 | Real-time communication |
| stf-api | 3000 | 3700 | REST APIs |
| stf-storage-apk | 3000 | 3300 | APK storage |
| stf-storage-image | 3000 | 3400 | Image storage |
| stf-storage-temp | 3000 | 3500 | Temporary storage |
| stf-provider | 15000-15100 | 15000-15100 | Device ports |
| nginx | 80,443 | 80,443 | Reverse proxy | 