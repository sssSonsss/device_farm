#!/bin/bash

echo "🔧 Sửa redirect loop trong STF"
echo "================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# 1. Kiểm tra database
echo -e "\n${YELLOW}📊 Kiểm tra database...${NC}"
docker exec -it stf-api stf migrate

# 2. Tạo thêm fake devices
echo -e "\n${YELLOW}📱 Tạo thêm fake devices...${NC}"
docker exec -it stf-api stf generate-fake-device "Samsung Galaxy S21" --number 5
docker exec -it stf-api stf generate-fake-device "iPhone 13" --number 3
docker exec -it stf-api stf generate-fake-device "Google Pixel 6" --number 2

# 3. Kiểm tra services
echo -e "\n${YELLOW}🔍 Kiểm tra services...${NC}"
docker ps | grep stf

# 4. Test authentication flow
echo -e "\n${YELLOW}🔐 Test authentication flow...${NC}"

# Lấy CSRF token
echo -e "${BLUE}1. Lấy CSRF token...${NC}"
CSRF_TOKEN=$(curl -s -c cookies.txt http://10.28.146.50:8081/auth/mock/ | grep -o 'XSRF-TOKEN=[^;]*' | cut -d'=' -f2)
echo "CSRF Token: $CSRF_TOKEN"

# Login với CSRF token
echo -e "\n${BLUE}2. Login với CSRF token...${NC}"
curl -c cookies.txt -b cookies.txt -X POST http://10.28.146.50:8081/auth/api/v1/mock \
  -H "Content-Type: application/json" \
  -H "X-XSRF-TOKEN: $CSRF_TOKEN" \
  -d '{"email":"administrator@fakedomain.com","name":"administrator"}' \
  -v

# 5. Test dashboard access
echo -e "\n${YELLOW}🌐 Test dashboard access...${NC}"
curl -b cookies.txt -I http://10.28.146.50:8081/

echo -e "\n${GREEN}✅ Hoàn tất!${NC}"
echo -e "${BLUE}Thử truy cập: http://10.28.146.50:8081/${NC}"
echo -e "${BLUE}Login với: administrator@fakedomain.com / password${NC}"
