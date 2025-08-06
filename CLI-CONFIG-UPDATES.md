# STF CLI Configuration Updates

## Overview
Đã cập nhật các file CLI configuration cho các services chính để hỗ trợ database connection options.

## Files Updated

### 1. `lib/cli/auth-mock/index.js`
**Thêm options:**
- `--db-host` (default: rethinkdb)
- `--db-port` (default: 28015)
- `--db-name` (default: stf)

**Handler changes:**
- Set environment variables: `RETHINKDB_PORT_28015_TCP`, `RETHINKDB_ENV_DATABASE`

### 2. `lib/cli/app/index.js`
**Thêm options:**
- `--db-host` (default: rethinkdb)
- `--db-port` (default: 28015)
- `--db-name` (default: stf)

**Handler changes:**
- Set environment variables: `RETHINKDB_PORT_28015_TCP`, `RETHINKDB_ENV_DATABASE`

### 3. `lib/cli/websocket/index.js`
**Thêm options:**
- `--db-host` (default: rethinkdb)
- `--db-port` (default: 28015)
- `--db-name` (default: stf)

**Handler changes:**
- Set environment variables: `RETHINKDB_PORT_28015_TCP`, `RETHINKDB_ENV_DATABASE`

### 4. `lib/cli/api/index.js`
**Thêm options:**
- `--db-host` (default: rethinkdb)
- `--db-port` (default: 28015)
- `--db-name` (default: stf)

**Handler changes:**
- Set environment variables: `RETHINKDB_PORT_28015_TCP`, `RETHINKDB_ENV_DATABASE`

## Docker Compose Updates

### `docker-compose-prod.yaml`
**Cập nhật cho tất cả services:**

#### stf-auth:
```yaml
command: >
  stf auth-mock --port 7120 
                --app-url http://stf-app:7105/ 
                --secret 12341234
                --db-host rethinkdb
                --db-port 28015
                --db-name stf
```

#### stf-app:
```yaml
command: >
  stf app --port 7105 
          --auth-url http://stf-auth:7120/auth/mock/ 
          --websocket-url ws://stf-websocket:3600/ 
          --secret your_session_secret
          --db-host rethinkdb
          --db-port 28015
          --db-name stf
```

#### stf-websocket:
```yaml
command: >
  stf websocket --port 3000 
                --storage-url http://stf-app:7105/ 
                --connect-push tcp://172.20.10.2:7170 
                --connect-sub tcp://172.20.10.2:7150 
                --secret your_session_secret
                --db-host rethinkdb
                --db-port 28015
                --db-name stf
```

#### stf-api:
```yaml
command: >
  stf api --port 3000 
          --connect-push tcp://172.20.10.2:7170 
          --connect-sub tcp://172.20.10.2:7150 
          --connect-push-dev tcp://172.20.10.2:7270 
          --connect-sub-dev tcp://172.20.10.2:7250 
          --secret your_session_secret
          --db-host rethinkdb
          --db-port 28015
          --db-name stf
```

## Health Check Updates

**Thay đổi từ curl sang wget:**
```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -q --spider http://localhost:PORT || exit 1"]
  interval: 10s
  timeout: 5s
  retries: 5
  start_period: 20s
```

## Environment Variables

**Tất cả services đều có:**
```yaml
environment:
  - SECRET=your_session_secret
  - RETHINKDB_HOST=rethinkdb
  - RETHINKDB_PORT=28015
  - RETHINKDB_ENV_DATABASE=stf
```

## Usage

### Command Line Examples:
```bash
# Auth service
stf auth-mock --port 7120 --secret 12341234 --db-host rethinkdb --db-port 28015 --db-name stf

# App service
stf app --port 7105 --auth-url http://stf-auth:7120/auth/mock/ --db-host rethinkdb --db-port 28015 --db-name stf

# WebSocket service
stf websocket --port 3000 --storage-url http://stf-app:7105/ --db-host rethinkdb --db-port 28015 --db-name stf

# API service
stf api --port 3000 --db-host rethinkdb --db-port 28015 --db-name stf
```

### Environment Variables:
```bash
export RETHINKDB_HOST=rethinkdb
export RETHINKDB_PORT=28015
export RETHINKDB_ENV_DATABASE=stf
```

## Benefits

1. **Consistent Database Connection**: Tất cả services đều có cùng cách kết nối database
2. **Flexible Configuration**: Có thể override qua command line hoặc environment variables
3. **Better Error Handling**: Database connection errors sẽ được xử lý đúng cách
4. **Health Check Compatibility**: Sử dụng wget thay vì curl để tương thích với containers

## Testing

### Test Database Connection:
```bash
# Test auth service
docker exec stf-auth wget -q --spider http://localhost:7120

# Test app service
docker exec stf-app wget -q --spider http://localhost:7105

# Test websocket service
docker exec stf-websocket wget -q --spider http://localhost:3000

# Test api service
docker exec stf-api wget -q --spider http://localhost:3000
```

### Check Logs:
```bash
# Check database connection logs
docker compose -f docker-compose-prod.yaml logs stf-auth | grep -i "database\|rethinkdb"
docker compose -f docker-compose-prod.yaml logs stf-app | grep -i "database\|rethinkdb"
docker compose -f docker-compose-prod.yaml logs stf-websocket | grep -i "database\|rethinkdb"
docker compose -f docker-compose-prod.yaml logs stf-api | grep -i "database\|rethinkdb"
``` 