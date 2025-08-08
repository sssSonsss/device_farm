# Phân tích quy trình khởi tạo STF Database

## 🔍 **Quy trình khởi tạo:**

### **1. Command `stf migrate`:**
- **File:** `lib/cli/migrate/index.js`
- **Chức năng:** Khởi tạo database và tạo bootstrap data
- **Quy trình:**
  1. Gọi `db.setup()` để tạo database và tables
  2. Kiểm tra root group có tồn tại không
  3. Nếu không có → gọi `dbapi.createBootStrap(env)`
  4. Nếu có → gọi `dbapi.updateBootStrap(group, env)`

### **2. Database Setup (`lib/db/setup.js`):**
- Tạo database "stf"
- Tạo các tables: users, devices, groups, accessTokens, vncauth, logs
- Tạo các indexes cần thiết

### **3. Bootstrap Creation (`lib/db/api.js` - hàm `createBootStrap`):**
- Tạo root group với tên "Common"
- Tạo admin user: `administrator@fakedomain.com`
- Gán quyền ADMIN cho user này
- Tạo các cấu hình mặc định

### **4. User Creation (`lib/db/api.js` - hàm `createUser`):**
- Tạo user với email, name, ip
- Gán privilege: ADMIN hoặc USER
- Tạo quotas và settings mặc định
- Thêm user vào root group

## 🔐 **Authentication Flow:**

### **1. Middleware Auth (`lib/units/app/middleware/auth.js`):**
```javascript
// Kiểm tra JWT token trong query
if (req.query.jwt) {
  // Decode JWT và lưu session
  dbapi.saveUserAfterLogin({...})
  res.redirect(redir) // Redirect để loại bỏ JWT
}
// Kiểm tra session
else if (req.session && req.session.jwt) {
  dbapi.loadUser(req.session.jwt.email)
  // Nếu user tồn tại → tiếp tục
  // Nếu không → redirect về auth
}
// Không có session → redirect về auth
else {
  res.redirect(options.authUrl)
}
```

### **2. User Login (`lib/db/api.js` - hàm `saveUserAfterLogin`):**
- Kiểm tra user có tồn tại không
- Nếu không → tạo user mới
- Nếu có → cập nhật thông tin login

## 🚨 **Nguyên nhân redirect loop:**

### **Vấn đề chính:**
1. **User đã tồn tại** trong database (đã được tạo bởi `stf migrate`)
2. **JWT token hợp lệ** nhưng session không được lưu đúng cách
3. **Middleware auth** redirect về `/auth/mock/` vì không tìm thấy session

### **Giải pháp:**
1. ✅ **Database đã được khởi tạo đúng**
2. ✅ **Admin user đã tồn tại**
3. ✅ **Fake devices đã được tạo**
4. ❌ **Vấn đề session management**

## 🛠️ **Cách sửa:**

### **1. Kiểm tra session configuration:**
- Đảm bảo cookie session được set đúng
- Kiểm tra secret key trong stf-app

### **2. Test authentication flow:**
- Truy cập login page
- Login với credentials đúng
- Kiểm tra session được tạo

### **3. Debug session:**
- Kiểm tra cookies trong browser
- Kiểm tra session storage
- Kiểm tra JWT token validation
