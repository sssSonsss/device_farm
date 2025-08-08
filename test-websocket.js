const WebSocket = require('ws');

// Test WebSocket connection
const ws = new WebSocket('ws://10.28.146.50:8081/socket.io/', {
  headers: {
    'Cookie': 'ssid=eyJjc3JmU2VjcmV0IjoiMGJEaEJ6Y2JwOWVBc2NoajNKdW53NW9NIiwiand0Ijp7ImVtYWlsIjoiYWRtaW5pc3RyYXRvckBmYWtlZG9tYWluLmNvbSIsIm5hbWUiOiJhZG1pbmlzdHJhdG9yIn19'
  }
});

ws.on('open', function open() {
  console.log('WebSocket connected successfully!');
  ws.close();
});

ws.on('error', function error(err) {
  console.error('WebSocket error:', err.message);
});

ws.on('close', function close() {
  console.log('WebSocket closed');
});

setTimeout(() => {
  console.log('Test completed');
  process.exit(0);
}, 5000);
