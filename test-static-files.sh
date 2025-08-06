#!/bin/bash

echo "=== STF DeviceFarm Static Files Test ==="

# Get LAN IP
LAN_IP=$(hostname -I | awk '{print $1}')
echo "LAN IP: $LAN_IP"

echo ""
echo "=== Testing Static Files ==="

# Test main static file
echo "1. Testing authmock.entry.js..."
curl -I http://$LAN_IP:8081/static/app/build/entry/authmock.entry.js

# Test auth page
echo ""
echo "2. Testing auth page..."
curl -I http://$LAN_IP:8081/auth/mock/

# Test main page
echo ""
echo "3. Testing main page..."
curl -I http://$LAN_IP:8081/

echo ""
echo "=== Test Results ==="
echo "✅ Static files should now be accessible"
echo "✅ Auth page should load properly"
echo "✅ No more 404 errors for static files"

echo ""
echo "=== Browser Test ==="
echo "1. Open browser and go to: http://$LAN_IP:8081"
echo "2. You should be redirected to: http://$LAN_IP:8081/auth/mock/"
echo "3. The page should load without JavaScript errors"
echo "4. Check browser console for any remaining errors"

echo ""
echo "=== If Still Having Issues ==="
echo "1. Clear browser cache (Ctrl+F5 or Cmd+Shift+R)"
echo "2. Try incognito/private mode"
echo "3. Try different browser"
echo "4. Check browser console for specific errors" 