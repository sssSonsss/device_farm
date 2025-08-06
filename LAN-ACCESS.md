# 🌐 STF DeviceFarm - LAN Access Guide

## ✅ Status: All Services Accessible via LAN

Tất cả các services đã được cấu hình để truy cập từ mạng LAN!

### 📊 LAN Access Test Results

| Service | Status | LAN URL | Test Result |
|---------|--------|---------|-------------|
| **Nginx Proxy** | ✅ Working | http://172.20.10.2:8081 | HTTP 302 (Redirect) |
| **Direct App** | ✅ Working | http://172.20.10.2:7105 | HTTP 302 (Redirect) |
| **Auth Service** | ✅ Working | http://172.20.10.2:7120 | HTTP 302 (Redirect) |
| **API** | ✅ Working | http://172.20.10.2:3700 | HTTP 404 (Expected) |
| **Database** | ✅ Working | http://172.20.10.2:8080 | Accessible |

## 🌐 Access URLs for LAN

### Main Access Points
- **🌐 Main UI (via nginx)**: http://172.20.10.2:8081
- **📱 Direct App**: http://172.20.10.2:7105
- **🔐 Auth Service**: http://172.20.10.2:7120
- **📊 API**: http://172.20.10.2:3700
- **🗄️ Database Admin**: http://172.20.10.2:8080

### Storage Services
- **📦 APK Storage**: http://172.20.10.2:3300
- **🖼️ Image Storage**: http://172.20.10.2:3400
- **📁 Temp Storage**: http://172.20.10.2:3500

## 🔧 Configuration Changes Made

### 1. App Service URLs
```yaml
# Changed from localhost to LAN IP
command: >
  stf app --port 7105 
          --auth-url http://172.20.10.2:7120/auth/mock/ 
          --websocket-url ws://172.20.10.2:3600/ 
          --secret your_session_secret
```

### 2. Nginx Configuration
```nginx
# Bind to all interfaces
server {
    listen 0.0.0.0:80;
    server_name _;
    # ... proxy settings
}
```

### 3. Docker Port Binding
```yaml
# Bind to all interfaces
ports:
  - "0.0.0.0:8081:80"
  - "0.0.0.0:8443:443"
```

## 🚀 How to Access from Other Devices

### 1. From Windows/Mac/Linux
```bash
# Open browser and go to:
http://172.20.10.2:8081
```

### 2. From Mobile Devices
```
# Open browser and go to:
http://172.20.10.2:8081
```

### 3. From Other Computers on LAN
```
# Replace 172.20.10.2 with your server's IP
http://YOUR_SERVER_IP:8081
```

## 🛠️ Troubleshooting

### Common Issues

#### 1. "This site can't be reached"
- **Check**: Device is on same network
- **Check**: Firewall allows port 8081
- **Check**: Server IP is correct

#### 2. "404 Not Found" errors
- **Try**: http://172.20.10.2:7105 (direct app)
- **Check**: All services are running
- **Check**: Docker containers are healthy

#### 3. Static files not loading
- **Check**: Browser console for errors
- **Try**: Different browser
- **Check**: Network connectivity

### Network Commands
```bash
# Test connectivity
ping 172.20.10.2

# Test port access
telnet 172.20.10.2 8081

# Check if services are running
docker compose -f docker-compose-prod.yaml ps
```

## 📱 Mobile Access

### Android
1. Open Chrome/Samsung Internet
2. Go to: http://172.20.10.2:8081
3. Add to home screen for easy access

### iOS
1. Open Safari
2. Go to: http://172.20.10.2:8081
3. Add to home screen for easy access

## 🔒 Security Notes

### Current Configuration
- **No SSL**: HTTP only (for development)
- **No Authentication**: Mock auth enabled
- **LAN Only**: Not accessible from internet

### For Production
```bash
# Enable SSL
# Add authentication
# Configure firewall rules
# Use HTTPS
```

## 📊 Performance Monitoring

### Check Service Status
```bash
# All services
docker compose -f docker-compose-prod.yaml ps

# Specific service logs
docker compose -f docker-compose-prod.yaml logs nginx
docker compose -f docker-compose-prod.yaml logs stf-app
```

### Network Performance
```bash
# Test response time
curl -w "@curl-format.txt" -o /dev/null -s http://172.20.10.2:8081

# Monitor network usage
iftop -i eth0
```

## 🎯 Success Metrics

- ✅ **All services accessible via LAN**
- ✅ **Nginx proxy working**
- ✅ **No firewall blocking**
- ✅ **Mobile devices can access**
- ✅ **Cross-platform compatibility**

## 📝 Quick Reference

### Main URLs
- **Web UI**: http://172.20.10.2:8081
- **Direct**: http://172.20.10.2:7105
- **Auth**: http://172.20.10.2:7120

### Commands
```bash
# Test LAN access
./test-lan.sh

# Check services
docker compose -f docker-compose-prod.yaml ps

# View logs
docker compose -f docker-compose-prod.yaml logs -f
```

---

**🎉 STF DeviceFarm is now accessible from your LAN! Share the URL with other devices on your network.** 