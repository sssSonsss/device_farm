#!/bin/bash

echo "🔍 Kiểm tra trạng thái STF"
echo "================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# 1. Kiểm tra containers
echo -e "\n${YELLOW}📦 Kiểm tra containers...${NC}"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep stf

# 2. Kiểm tra database
echo -e "\n${YELLOW}🗄️ Kiểm tra database...${NC}"
docker exec -it stf-api stf migrate 2>/dev/null | grep -E "(Database|Table|Index)" | tail -5

# 3. Kiểm tra fake devices
echo -e "\n${YELLOW}📱 Kiểm tra fake devices...${NC}"
curl -s http://10.28.146.50:8081/api/v1/devices | jq '.devices | length' 2>/dev/null || echo "Không thể kết nối API"

# 4. Kiểm tra user settings
echo -e "\n${YELLOW}👤 Kiểm tra user settings...${NC}"
docker exec -it stf-api node -e "
const dbapi = require('./lib/db/api');
dbapi.loadUser('administrator@fakedomain.com').then(user => {
  console.log('User settings:', JSON.stringify(user.settings, null, 2));
}).catch(console.error);
" 2>/dev/null

# 5. Kiểm tra WebSocket
echo -e "\n${YELLOW}🔌 Kiểm tra WebSocket...${NC}"
curl -I http://10.28.146.50:8081/socket.io/ 2>/dev/null | head -1

# 6. Kiểm tra authentication
echo -e "\n${YELLOW}🔐 Kiểm tra authentication...${NC}"
curl -I http://10.28.146.50:8081/auth/mock/ 2>/dev/null | head -1

echo -e "\n${GREEN}✅ Kiểm tra hoàn tất!${NC}"
echo -e "${BLUE}Truy cập: http://10.28.146.50:8081/${NC}"
echo -e "${BLUE}Login: administrator@fakedomain.com${NC}"
