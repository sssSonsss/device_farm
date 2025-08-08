// Tạo JWT token đơn giản
const crypto = require('crypto');

// Tạo payload
const payload = {
  email: 'administrator@fakedomain.com',
  name: 'administrator'
};

// Tạo header
const header = {
  alg: 'HS256',
  typ: 'JWT'
};

// Encode base64
const encodeBase64 = (obj) => {
  return Buffer.from(JSON.stringify(obj)).toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=/g, '');
};

// Tạo signature
const createSignature = (header, payload, secret) => {
  const data = header + '.' + payload;
  const signature = crypto.createHmac('sha256', secret).update(data).digest('base64');
  return signature.replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '');
};

const secret = '12341234';
const encodedHeader = encodeBase64(header);
const encodedPayload = encodeBase64(payload);
const signature = createSignature(encodedHeader, encodedPayload, secret);

const token = encodedHeader + '.' + encodedPayload + '.' + signature;

console.log('JWT Token:', token);
console.log('Test URL:', `http://10.28.146.50:8081/?jwt=${token}`);
