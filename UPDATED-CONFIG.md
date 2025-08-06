# STF DeviceFarm Updated Configuration

## Recent Changes (Latest Update)

### 1. Fixed Database Connection Issues

#### Updated `lib/cli/auth-mock/index.js`
- Added `db-host` option with default value from `RETHINKDB_HOST` environment variable
- Added `db-port` option with default value from `RETHINKDB_PORT` environment variable  
- Added `db-name` option with default value from `RETHINKDB_ENV_DATABASE` environment variable
- Updated handler to set database environment variables before starting the service

### 2. Updated Docker Compose Configuration

#### `docker-compose-prod.yaml` Changes:
- **stf-auth service**:
  - Port changed from `3200:3000` to `7120:7120`
  - Command updated to use port 7120 and secret 12341234
  - Added database environment variables
  - Added `depends_on` with health check for rethinkdb
  - Updated health check to use port 7120

- **stf-app service**:
  - Port changed from `3100:3000` to `7105:7105`
  - Command updated to use port 7105
  - Updated auth-url to point to stf-auth:7120
  - Updated health check to use port 7105

### 3. Updated Nginx Configuration

#### `nginx.conf` Changes:
- Updated `stf_app` upstream to use port 7105
- Updated `stf_auth` upstream to use port 7120

### 4. New Scripts

#### `rebuild-devicefarm.sh`
- Script to rebuild image and restart services with new configuration
- Includes stopping existing services, removing old image, building new image
- Automatically creates network and starts services
- Provides status checking and helpful output

## Current Port Configuration

| Service | Internal Port | External Port | URL |
|---------|---------------|---------------|-----|
| STF App | 7105 | 7105 | http://localhost:7105 |
| STF Auth | 7120 | 7120 | http://localhost:7120 |
| STF API | 3700 | 3700 | http://localhost:3700 |
| STF WebSocket | 3600 | 3600 | ws://localhost:3600 |
| Nginx | 80 | 80 | http://localhost |

## Database Configuration

### Environment Variables
- `RETHINKDB_HOST=rethinkdb`
- `RETHINKDB_PORT=28015`
- `RETHINKDB_ENV_DATABASE=stf`

### Command Line Options
- `--db-host rethinkdb`
- `--db-port 28015`
- `--db-name stf`

## Usage Instructions

### Quick Start
```bash
# Rebuild and start with new configuration
./rebuild-devicefarm.sh
```

### Manual Steps
```bash
# Build new image
./build-devicefarm.sh

# Create network
docker network create stf-network

# Start services
docker compose -f docker-compose-prod.yaml up -d
```

### Check Status
```bash
# View service status
docker compose -f docker-compose-prod.yaml ps

# View logs
docker compose -f docker-compose-prod.yaml logs -f stf-auth
```

## Troubleshooting

### Database Connection Issues
1. Ensure rethinkdb service is running and healthy
2. Check environment variables are set correctly
3. Verify network connectivity between services

### Port Issues
1. Check if ports 7105 and 7120 are available
2. Verify nginx configuration matches service ports
3. Ensure firewall allows connections to these ports

### Service Health
1. Check health status: `docker compose -f docker-compose-prod.yaml ps`
2. View logs: `docker compose -f docker-compose-prod.yaml logs -f`
3. Restart specific service: `docker compose -f docker-compose-prod.yaml restart stf-auth`

## Testing the Configuration

### Test Database Connection
```bash
# Check if auth service can connect to database
docker compose -f docker-compose-prod.yaml logs stf-auth | grep -i "database\|rethinkdb"
```

### Test Service Endpoints
```bash
# Test auth endpoint
curl -f http://localhost:7120

# Test app endpoint  
curl -f http://localhost:7105
```

### Test Complete Flow
1. Access http://localhost (nginx proxy)
2. Should redirect to auth service
3. Auth service should connect to database successfully
4. No more "db-host" errors 