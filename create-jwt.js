const jwt = require('jsonwebtoken');

// Tạo JWT token với secret key đúng
const payload = {
  email: 'administrator@fakedomain.com',
  name: 'administrator'
};

const secret = '12341234';
const token = jwt.sign(payload, secret, { expiresIn: '24h' });

console.log('JWT Token:', token);
console.log('Decoded:', jwt.verify(token, secret));
