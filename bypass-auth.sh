#!/bin/bash

echo "🔓 Bypassing STF Authentication"
echo "================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Create more fake devices
echo -e "\n${YELLOW}📱 Creating more fake devices...${NC}"
docker exec -it stf-api stf generate-fake-device "Samsung Galaxy S21" --number 3
docker exec -it stf-api stf generate-fake-device "iPhone 13" --number 2
docker exec -it stf-api stf generate-fake-device "Google Pixel 6" --number 2

# Check if devices are in database
echo -e "\n${YELLOW}🗄️ Checking devices in database...${NC}"
docker exec -it stf-api stf doctor

# Try to access dashboard with different approaches
echo -e "\n${YELLOW}🌐 Testing dashboard access...${NC}"

# Method 1: Direct access with JWT
JWT_TOKEN="eyJhbGciOiJIUzI1NiIsImV4cCI6MTc1NDYyMjU5NTAwOX0.eyJlbWFpbCI6ImFkbWluaXN0cmF0b3JAZmFrZWRvbWFpbi5jb20iLCJuYW1lIjoiYWRtaW5pc3RyYXRvciJ9.nYBr8sO3N-fXD2VdzWxla6mzpZZnpOSsE8pvGDRT8MA"
echo -e "${BLUE}Method 1: Direct JWT access${NC}"
curl -s "http://10.28.146.50:7105/?jwt=$JWT_TOKEN" | grep -i "device\|dashboard\|login" | head -3

# Method 2: Access via nginx
echo -e "\n${BLUE}Method 2: Nginx proxy access${NC}"
curl -s "http://10.28.146.50:8081/?jwt=$JWT_TOKEN" | grep -i "device\|dashboard\|login" | head -3

# Method 3: Try to access API directly
echo -e "\n${BLUE}Method 3: API direct access${NC}"
curl -s "http://10.28.146.50:3700/api/v1/devices" | head -3

# Method 4: Check if we can access static files
echo -e "\n${BLUE}Method 4: Static files access${NC}"
curl -s "http://10.28.146.50:8081/static/app/build/" | head -3

echo -e "\n${GREEN}✅ Testing completed!${NC}"
echo -e "${YELLOW}📋 Manual steps to try:${NC}"
echo -e "${BLUE}1. Open browser and go to: http://10.28.146.50:8081/${NC}"
echo -e "${BLUE}2. Login with: administrator@fakedomain.com / password${NC}"
echo -e "${BLUE}3. If still redirecting, try: http://10.28.146.50:7105/${NC}"
echo -e "${BLUE}4. Check if devices appear in the dashboard${NC}"
