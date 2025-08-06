# 🔧 CLI Database Options Fixes

## ✅ Đã sửa các file CLI để hỗ trợ database options

### **Các file đã được cập nhật:**

#### 1. **lib/cli/auth-mock/index.js**
- ✅ **Builder**: Đã có options `db-host`, `db-port`, `db-name`
- ✅ **Handler**: Đã thêm `dbHost`, `dbPort`, `dbName` vào parameters
- ✅ **Thứ tự**: Sắp xếp lại thứ tự parameters cho đúng

#### 2. **lib/cli/app/index.js**
- ✅ **Builder**: Đã có options `db-host`, `db-port`, `db-name`
- ✅ **Handler**: Đã thêm `dbHost`, `dbPort`, `dbName` vào parameters

#### 3. **lib/cli/websocket/index.js**
- ✅ **Builder**: Đã có options `db-host`, `db-port`, `db-name`
- ✅ **Handler**: Đã thêm `dbHost`, `dbPort`, `dbName` vào parameters

#### 4. **lib/cli/api/index.js**
- ✅ **Builder**: Đã có options `db-host`, `db-port`, `db-name`
- ✅ **Handler**: Đã thêm `dbHost`, `dbPort`, `dbName` vào parameters

## 📋 **Tóm tắt thay đổi:**

### **Trước khi sửa:**
```javascript
// Chỉ có trong builder, không có trong handler
.option('db-host', {
  describe: 'Database host address.'
, type: 'string'
, default: process.env.RETHINKDB_HOST || 'rethinkdb'
})
```

### **Sau khi sửa:**
```javascript
// Có trong cả builder và handler
.option('db-host', {
  describe: 'Database host address.'
, type: 'string'
, default: process.env.RETHINKDB_HOST || 'rethinkdb'
})

// Trong handler:
return require('../../units/service')({
  // ... other options
  , dbHost: argv.dbHost
  , dbPort: argv.dbPort
  , dbName: argv.dbName
})
```

## 🎯 **Lý do cần sửa:**

1. **Database Connection**: Các services cần kết nối database để hoạt động
2. **Environment Variables**: Cần truyền database config từ CLI đến service
3. **Docker Integration**: Để hoạt động với Docker Compose setup
4. **Flexibility**: Cho phép cấu hình database khác nhau cho môi trường khác nhau

## ✅ **Kết quả:**

- ✅ Tất cả CLI commands giờ đây hỗ trợ database options
- ✅ Có thể sử dụng `--db-host`, `--db-port`, `--db-name` arguments
- ✅ Environment variables được hỗ trợ: `RETHINKDB_HOST`, `RETHINKDB_PORT`, `RETHINKDB_ENV_DATABASE`
- ✅ Services sẽ nhận được database configuration đúng cách

## 🚀 **Cách sử dụng:**

```bash
# Sử dụng arguments
stf auth-mock --db-host rethinkdb --db-port 28015 --db-name stf

# Sử dụng environment variables
RETHINKDB_HOST=rethinkdb RETHINKDB_PORT=28015 RETHINKDB_ENV_DATABASE=stf stf auth-mock
```

---

**Tất cả CLI commands giờ đây đã hỗ trợ đầy đủ database configuration!** 🎉 