#!/bin/bash

echo "🔍 Testing STF Dashboard with Fake Devices"
echo "=========================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if fake devices exist
echo -e "\n${YELLOW}📱 Checking fake devices...${NC}"
docker exec -it stf-api stf generate-fake-device "Samsung Galaxy S21" --number 1
docker exec -it stf-api stf generate-fake-device "iPhone 13" --number 1
docker exec -it stf-api stf generate-fake-device "Google Pixel 6" --number 1

# Check devices in database
echo -e "\n${YELLOW}🗄️ Checking devices in database...${NC}"
docker exec -it stf-api stf doctor

# Test direct access to app
echo -e "\n${YELLOW}🌐 Testing direct app access...${NC}"
curl -s "http://10.28.146.50:7105/" | head -10

# Test with JWT token
echo -e "\n${YELLOW}🔐 Testing with JWT token...${NC}"
JWT_TOKEN="eyJhbGciOiJIUzI1NiIsImV4cCI6MTc1NDYyMjU5NTAwOX0.eyJlbWFpbCI6ImFkbWluaXN0cmF0b3JAZmFrZWRvbWFpbi5jb20iLCJuYW1lIjoiYWRtaW5pc3RyYXRvciJ9.nYBr8sO3N-fXD2VdzWxla6mzpZZnpOSsE8pvGDRT8MA"
curl -s "http://10.28.146.50:7105/?jwt=$JWT_TOKEN" | head -10

# Check API endpoints
echo -e "\n${YELLOW}🔌 Testing API endpoints...${NC}"
curl -s "http://10.28.146.50:3700/api/v1/devices" | head -5

echo -e "\n${GREEN}✅ Testing completed!${NC}"
echo -e "${BLUE}Access STF at: http://10.28.146.50:8081/${NC}"
echo -e "${BLUE}Login with: administrator@fakedomain.com / password${NC}"
