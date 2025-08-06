# 📋 TỔNG HỢP TẤT CẢ LỖI ĐÃ GẶP VÀ CÁCH GIẢI QUYẾT

## 🚨 Danh sách tất cả lỗi đã gặp phải

### 1. **Lỗi Docker Compose Command**
```
❌ Lỗi: Command 'docker-compose' not found
```

**🔍 Nguyên nhân:**
- Docker Compose đã được đổi tên từ `docker-compose` thành `docker compose` (không có dấu gạch ngang)

**✅ Cách giải quyết:**
```bash
# Thay đổi tất cả lệnh từ:
docker-compose -f docker-compose-prod.yaml up

# Thành:
docker compose -f docker-compose-prod.yaml up
```

**📝 Giải thích:**
Docker đã deprecated `docker-compose` command và chuyển sang `docker compose` để thống nhất với Docker CLI.

---

### 2. **Lỗi Container Name Conflict**
```
❌ Lỗi: Error response from daemon: Conflict. The container name "/stf-storage-temp" is already in use.
```

**🔍 Nguyên nhân:**
- Container cũ vẫn tồn tại từ lần chạy trước
- Docker không thể tạo container mới với tên đã tồn tại

**✅ Cách giải quyết:**
```bash
# Xóa container cũ
docker rm -f stf-storage-temp

# Hoặc xóa tất cả containers
docker rm -f $(docker ps -aq)

# Sau đó chạy lại
docker compose -f docker-compose-prod.yaml up -d
```

**📝 Giải thích:**
Khi container bị stop nhưng không bị xóa, Docker sẽ giữ lại tên container. Cần xóa container cũ trước khi tạo mới.

---

### 3. **Lỗi Health Check Missing**
```
❌ Lỗi: dependency failed to start: container rethinkdb has no healthcheck configured
```

**🔍 Nguyên nhân:**
- Service `stf-auth` phụ thuộc vào `rethinkdb` với điều kiện `service_healthy`
- Nhưng `rethinkdb` không có health check

**✅ Cách giải quyết:**
```yaml
# Thêm health check cho rethinkdb
rethinkdb:
  image: rethinkdb:2.4.2
  ports:
    - "8080:8080"
    - "28015:28015"
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost:8080 || exit 1"]
    interval: 10s
    timeout: 5s
    retries: 5
    start_period: 30s
```

**📝 Giải thích:**
Docker Compose `depends_on` với `condition: service_healthy` yêu cầu service phải có health check để xác định service đã sẵn sàng.

---

### 4. **Lỗi Database Connection**
```
❌ Lỗi: Connecting to 127.0.0.1:28015 instead of rethinkdb
```

**🔍 Nguyên nhân:**
- STF services không nhận được environment variables cho database
- Services kết nối đến localhost thay vì container name

**✅ Cách giải quyết:**
```yaml
# Thêm environment variables
environment:
  - RETHINKDB_HOST=rethinkdb
  - RETHINKDB_PORT=28015
  - RETHINKDB_ENV_DATABASE=stf
```

**📝 Giải thích:**
STF sử dụng environment variables để kết nối database. Nếu không có, nó sẽ dùng localhost mặc định.

---

### 5. **Lỗi Health Check Tool Missing**
```
❌ Lỗi: curl: command not found in container
```

**🔍 Nguyên nhân:**
- Container không có `curl` command
- Health check sử dụng `curl` nhưng tool không có sẵn

**✅ Cách giải quyết:**
```yaml
# Thay đổi health check từ curl sang wget
healthcheck:
  test: ["CMD-SHELL", "wget -q --spider http://localhost:7120 || exit 1"]
  interval: 10s
  timeout: 5s
  retries: 5
```

**📝 Giải thích:**
Container base image không có `curl` nhưng có `wget`. Cần sử dụng tool có sẵn trong container.

---

### 6. **Lỗi Service Dependencies**
```
❌ Lỗi: dependency failed to start: container stf-auth has no healthcheck configured
```

**🔍 Nguyên nhân:**
- Sau khi xóa health check theo user's "working sample"
- Services vẫn phụ thuộc vào `service_healthy`

**✅ Cách giải quyết:**
```yaml
# Thay đổi từ service_healthy sang service_started
depends_on:
  stf-auth:
    condition: service_started  # Thay vì service_healthy
```

**📝 Giải thích:**
Khi không có health check, chỉ cần đợi service start thay vì healthy.

---

### 7. **Lỗi Missing Required Argument**
```
❌ Lỗi: Missing required argument: storage-url
```

**🔍 Nguyên nhân:**
- `stf-provider` service thiếu argument `--storage-url`
- Đây là argument bắt buộc cho provider service

**✅ Cách giải quyết:**
```yaml
# Thêm storage-url argument
command: >
  stf provider --name "provider-1" 
               --min-port 15000 
               --max-port 25000 
               --storage-url http://stf-app:7105/
```

**📝 Giải thích:**
Provider service cần biết URL của storage service để lưu trữ files.

---

### 8. **Lỗi Port Already in Use**
```
❌ Lỗi: address already in use for port 80
```

**🔍 Nguyên nhân:**
- System nginx đang chạy trên port 80
- Docker container không thể bind vào port đã được sử dụng

**✅ Cách giải quyết:**
```yaml
# Thay đổi port mapping
ports:
  - "8081:80"  # Thay vì "80:80"
  - "8443:443" # Thay vì "443:443"
```

**📝 Giải thích:**
Host port 80 đã được sử dụng bởi system service. Cần dùng port khác cho container.

---

### 9. **Lỗi Nginx Configuration**
```
❌ Lỗi: a duplicate listen 0.0.0.0:80 in /etc/nginx/nginx.conf:29
```

**🔍 Nguyên nhân:**
- Nginx config có 2 dòng `listen` cho cùng port
- Cấu hình bị duplicate

**✅ Cách giải quyết:**
```nginx
# Xóa dòng listen trùng lặp
server {
    listen 0.0.0.0:80;  # Chỉ giữ lại 1 dòng này
    # Xóa dòng: listen 80;
    server_name _;
}
```

**📝 Giải thích:**
Nginx không cho phép 2 dòng `listen` cho cùng port. Cần xóa dòng trùng lặp.

---

### 10. **Lỗi LAN Access - Port Binding**
```
❌ Lỗi: curl: (7) Failed to connect to 172.20.10.2 port 8081
```

**🔍 Nguyên nhân:**
- Docker chỉ bind vào localhost (127.0.0.1)
- Không thể truy cập từ LAN IP

**✅ Cách giải quyết:**
```yaml
# Bind tới tất cả interfaces
ports:
  - "0.0.0.0:8081:80"
  - "0.0.0.0:8443:443"
```

**📝 Giải thích:**
Docker mặc định chỉ bind vào localhost. Cần bind vào `0.0.0.0` để truy cập từ LAN.

---

### 11. **Lỗi Static Files 404**
```
❌ Lỗi: Failed to load resource: the server responded with a status of 404 (Not Found)
❌ Lỗi: Refused to execute script ... because its MIME type ('text/html') is not executable
```

**🔍 Nguyên nhân:**
- Browser cố tải static files từ `localhost:7120`
- Auth service không serve static files
- Nginx không có route cho `/static/`

**✅ Cách giải quyết:**
```nginx
# Thêm static files location
location /static/ {
    proxy_pass http://stf_app;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

**📝 Giải thích:**
Static files được serve bởi app service, không phải auth service. Cần proxy `/static/` requests đến app service.

---

### 12. **Lỗi URL Redirection**
```
❌ Lỗi: Browser redirects to localhost instead of LAN IP
```

**🔍 Nguyên nhân:**
- STF app service được cấu hình với localhost URLs
- Browser redirects đến localhost khi truy cập từ LAN

**✅ Cách giải quyết:**
```yaml
# Thay đổi URLs sang LAN IP
command: >
  stf app --port 7105 
          --auth-url http://172.20.10.2:7120/auth/mock/ 
          --websocket-url ws://172.20.10.2:3600/
```

**📝 Giải thích:**
STF sử dụng URLs trong command để tạo redirects. Cần dùng LAN IP thay vì localhost.

---

## 🔧 **Tổng kết các nguyên tắc quan trọng:**

### 1. **Docker Compose Commands**
- Sử dụng `docker compose` (không có dấu gạch ngang)
- Luôn dùng `-f docker-compose-prod.yaml` để chỉ định file

### 2. **Service Dependencies**
- `service_healthy`: Cần health check
- `service_started`: Chỉ cần service start
- Luôn kiểm tra dependencies trước khi start

### 3. **Port Management**
- Tránh conflict với system services
- Bind `0.0.0.0` cho LAN access
- Sử dụng ports khác cho development

### 4. **Environment Variables**
- STF cần đúng environment variables cho database
- Kiểm tra logs để debug connection issues

### 5. **Static Files**
- Serve từ app service, không phải auth service
- Cần nginx proxy cho `/static/` path
- Kiểm tra MIME types

### 6. **LAN Access**
- Bind ports với `0.0.0.0`
- Sử dụng LAN IP trong URLs
- Test từ các devices khác nhau

---

## 🎯 **Các bước debug hiệu quả:**

1. **Kiểm tra logs:**
```bash
docker compose -f docker-compose-prod.yaml logs -f
```

2. **Kiểm tra service status:**
```bash
docker compose -f docker-compose-prod.yaml ps
```

3. **Test connectivity:**
```bash
curl -I http://localhost:PORT
curl -I http://LAN_IP:PORT
```

4. **Check container internals:**
```bash
docker exec CONTAINER_NAME command
```

5. **Restart services:**
```bash
docker compose -f docker-compose-prod.yaml restart SERVICE_NAME
```

---

## ✅ **Kết quả cuối cùng:**

Tất cả lỗi đã được giải quyết và STF DeviceFarm hiện đang hoạt động hoàn hảo trên LAN với:
- ✅ Tất cả services accessible
- ✅ Static files working
- ✅ No 404 errors
- ✅ Correct MIME types
- ✅ LAN access from any device
- ✅ Mobile compatibility 