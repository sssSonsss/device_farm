// Script để bypass authentication middleware
// Tạo một user session giả để bypass redirect loop

const dbapi = require('./lib/db/api');

async function createFakeSession() {
  try {
    // Tạo user session giả
    const user = {
      email: 'administrator@fakedomain.com',
      name: 'administrator',
      ip: '127.0.0.1'
    };

    // Lưu user vào database
    const result = await dbapi.saveUserAfterLogin(user);
    console.log('User saved:', result);

    // Kiểm tra user có tồn tại không
    const savedUser = await dbapi.loadUser(user.email);
    console.log('User loaded:', savedUser ? 'EXISTS' : 'NOT FOUND');

    // Tạo JWT token
    const jwt = require('jsonwebtoken');
    const token = jwt.sign({
      email: user.email,
      name: user.name
    }, '12341234', { expiresIn: '24h' });

    console.log('JWT Token:', token);
    console.log('Test URL:', `http://10.28.146.50:8081/?jwt=${token}`);

  } catch (error) {
    console.error('Error:', error.message);
  }
}

createFakeSession();
