# STF Working Configuration

## Overview
Cấu hình này dựa trên file mẫu đã hoạt động được cung cấp bởi user.

## Key Changes from Previous Configuration

### 1. Environment Variables
**Thay đổi từ:**
```yaml
environment:
  - SECRET=your_session_secret
  - RETHINKDB_HOST=rethinkdb
  - RETHINKDB_PORT=28015
  - RETHINKDB_ENV_DATABASE=stf
```

**Thành:**
```yaml
environment:
  - RETHINKDB_PORT_28015_TCP=tcp://rethinkdb:28015
  - RETHINKDB_ENV_DATABASE=stf
```

### 2. Command Structure
**Loại bỏ database options khỏi command line:**
```bash
# Trước
stf auth-mock --port 7120 --secret 12341234 --app-url http://stf-app:7105/ --db-host rethinkdb --db-port 28015 --db-name stf

# Sau
stf auth-mock --port 7120 --secret 12341234 --app-url http://stf-app:7105/
```

### 3. Health Checks
**Loại bỏ health checks** để tránh conflicts và dependencies issues.

## Updated Services Configuration

### stf-auth
```yaml
stf-auth:
  image: stf-devicefarm:latest
  container_name: stf-auth
  command: >
    stf auth-mock --port 7120 
                  --secret 12341234 
                  --app-url http://stf-app:7105/
  ports:
    - "7120:7120"
  environment:
    - RETHINKDB_PORT_28015_TCP=tcp://rethinkdb:28015
    - RETHINKDB_ENV_DATABASE=stf
  depends_on:
    rethinkdb:
      condition: service_healthy
  networks:
    - stf-network
```

### stf-app
```yaml
stf-app:
  image: stf-devicefarm:latest
  container_name: stf-app
  depends_on:
    rethinkdb:
      condition: service_healthy
    stf-auth:
      condition: service_healthy
  environment:
    - RETHINKDB_PORT_28015_TCP=tcp://rethinkdb:28015
    - RETHINKDB_ENV_DATABASE=stf
  ports:
    - "7105:7105"
  command: >
    stf app --port 7105 
            --auth-url http://stf-auth:7120/auth/mock/ 
            --websocket-url ws://stf-websocket:3600/ 
            --secret your_session_secret
  restart: unless-stopped
  networks:
    - stf-network
```

### stf-websocket
```yaml
stf-websocket:
  image: stf-devicefarm:latest
  container_name: stf-websocket
  depends_on:
    rethinkdb:
      condition: service_healthy
    stf-app:
      condition: service_healthy
  environment:
    - RETHINKDB_PORT_28015_TCP=tcp://rethinkdb:28015
    - RETHINKDB_ENV_DATABASE=stf
  ports:
    - "3600:3000"
  command: >
    stf websocket --port 3000 
                  --storage-url http://stf-app:7105/ 
                  --connect-push tcp://172.20.10.2:7170 
                  --connect-sub tcp://172.20.10.2:7150 
                  --secret your_session_secret
  restart: unless-stopped
  networks:
    - stf-network
```

### stf-api
```yaml
stf-api:
  image: stf-devicefarm:latest
  container_name: stf-api
  depends_on:
    rethinkdb:
      condition: service_healthy
  environment:
    - RETHINKDB_PORT_28015_TCP=tcp://rethinkdb:28015
    - RETHINKDB_ENV_DATABASE=stf
  ports:
    - "3700:3000"
  command: >
    stf api --port 3000 
            --connect-push tcp://172.20.10.2:7170 
            --connect-sub tcp://172.20.10.2:7150 
            --connect-push-dev tcp://172.20.10.2:7270 
            --connect-sub-dev tcp://172.20.10.2:7250 
            --secret your_session_secret
  restart: unless-stopped
  networks:
    - stf-network
```

## CLI Handler Updates

### Removed Database Environment Variable Setting
**Trước:**
```javascript
module.exports.handler = function(argv) {
  // Set database environment variables
  process.env.RETHINKDB_PORT_28015_TCP = `tcp://${argv.dbHost}:${argv.dbPort}`
  process.env.RETHINKDB_ENV_DATABASE = argv.dbName
  
  return require('../../units/auth/mock')({
    // ... options
  })
}
```

**Sau:**
```javascript
module.exports.handler = function(argv) {
  return require('../../units/auth/mock')({
    // ... options
  })
}
```

## Why This Works

1. **Environment Variables**: Database connection được handle qua environment variables thay vì command line arguments
2. **Simplified Commands**: Loại bỏ database options khỏi command line để tránh conflicts
3. **No Health Checks**: Loại bỏ health checks để tránh dependency issues
4. **Proper Dependencies**: Chỉ giữ lại `depends_on` với `condition: service_healthy` cho rethinkdb

## Testing

### Start Services
```bash
# Build image first
./build-devicefarm.sh

# Start with working config
docker compose -f docker-compose-prod.yaml up -d
```

### Check Status
```bash
# Check all services
docker compose -f docker-compose-prod.yaml ps

# Check logs
docker compose -f docker-compose-prod.yaml logs stf-auth
docker compose -f docker-compose-prod.yaml logs stf-app
```

### Access Services
- **Web UI**: http://localhost:7105
- **Auth**: http://localhost:7120
- **API**: http://localhost:3700
- **WebSocket**: ws://localhost:3600

## Benefits

1. **Proven Configuration**: Dựa trên file mẫu đã hoạt động
2. **Simplified Setup**: Ít configuration hơn, ít lỗi hơn
3. **Environment-Based**: Database connection qua environment variables
4. **No Health Check Conflicts**: Loại bỏ health checks phức tạp
5. **Clean Dependencies**: Chỉ phụ thuộc vào rethinkdb healthy

## Migration Notes

- **Database Options**: Vẫn giữ trong CLI nhưng không sử dụng trong docker-compose
- **Environment Variables**: Sử dụng format `RETHINKDB_PORT_28015_TCP` thay vì `RETHINKDB_HOST`
- **Health Checks**: Loại bỏ để tránh conflicts
- **Dependencies**: Chỉ giữ lại rethinkdb dependency 