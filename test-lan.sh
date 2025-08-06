#!/bin/bash

echo "=== STF DeviceFarm LAN Access Test ==="

# Get LAN IP
LAN_IP=$(hostname -I | awk '{print $1}')
echo "LAN IP: $LAN_IP"

echo ""
echo "=== Testing Services ==="

# Test nginx proxy
echo "1. Testing nginx proxy..."
curl -I http://$LAN_IP:8081

# Test direct app
echo ""
echo "2. Testing direct app..."
curl -I http://$LAN_IP:7105

# Test auth service
echo ""
echo "3. Testing auth service..."
curl -I http://$LAN_IP:7120

# Test API
echo ""
echo "4. Testing API..."
curl -I http://$LAN_IP:3700

echo ""
echo "=== Access URLs ==="
echo "Main UI (via nginx): http://$LAN_IP:8081"
echo "Direct App: http://$LAN_IP:7105"
echo "Auth Service: http://$LAN_IP:7120"
echo "API: http://$LAN_IP:3700"
echo "Database Admin: http://$LAN_IP:8080"

echo ""
echo "=== Instructions ==="
echo "1. Open browser and go to: http://$LAN_IP:8081"
echo "2. If you see 404 errors, try: http://$LAN_IP:7105"
echo "3. Make sure your device is on the same network"
echo "4. Check firewall settings if needed" 