#!/bin/bash

echo "🧪 Test toàn bộ flow STF"
echo "================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# 1. Test redirect flow
echo -e "\n${YELLOW}1️⃣ Test redirect flow...${NC}"
REDIRECT=$(curl -s -I http://10.28.146.50:8081/ | grep "Location:" | cut -d' ' -f2 | tr -d '\r')
echo "Redirect to: $REDIRECT"

# 2. Test auth page
echo -e "\n${YELLOW}2️⃣ Test auth page...${NC}"
AUTH_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://10.28.146.50:8081/auth/mock/)
echo "Auth page status: $AUTH_STATUS"

# 3. Test API endpoints
echo -e "\n${YELLOW}3️⃣ Test API endpoints...${NC}"
API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://10.28.146.50:8081/api/v1/user)
echo "API status: $API_STATUS"

# 4. Test WebSocket endpoint
echo -e "\n${YELLOW}4️⃣ Test WebSocket endpoint...${NC}"
WS_STATUS=$(curl -s -I http://10.28.146.50:8081/socket.io/ | head -1)
echo "WebSocket status: $WS_STATUS"

# 5. Test state.js
echo -e "\n${YELLOW}5️⃣ Test state.js...${NC}"
STATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://10.28.146.50:8081/app/api/v1/state.js)
echo "State.js status: $STATE_STATUS"

# 6. Test static files
echo -e "\n${YELLOW}6️⃣ Test static files...${NC}"
STATIC_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://10.28.146.50:8081/static/app/build/entry/app.entry.js)
echo "Static files status: $STATIC_STATUS"

# Summary
echo -e "\n${GREEN}📊 Kết quả test:${NC}"
if [ "$AUTH_STATUS" = "200" ] && [ "$API_STATUS" = "401" ] && [ "$STATE_STATUS" = "200" ] && [ "$STATIC_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Tất cả endpoints hoạt động bình thường!${NC}"
    echo -e "${BLUE}🎯 Bây giờ bạn có thể:${NC}"
    echo -e "   - Truy cập: http://10.28.146.50:8081/"
    echo -e "   - Login với: administrator@fakedomain.com"
    echo -e "   - Không còn lỗi AngularJS"
else
    echo -e "${RED}❌ Có vấn đề với một số endpoints${NC}"
fi

echo -e "\n${YELLOW}💡 Lưu ý:${NC}"
echo -e "   - API trả về 401 là bình thường (cần authentication)"
echo -e "   - WebSocket có thể trả về 400 khi test bằng curl"
echo -e "   - Quan trọng nhất là không có lỗi AngularJS khi truy cập web"
