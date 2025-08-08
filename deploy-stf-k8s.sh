#!/bin/bash

# STF DeviceFarm K8s Deployment Script
# Deploy STF lên Kubernetes và monitor logs

echo "🚀 STF DeviceFarm K8s Deployment"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        echo -e "${RED}❌ kubectl không được cài đặt${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ kubectl đã sẵn sàng${NC}"
}

# Function to create namespace
create_namespace() {
    echo -e "\n${YELLOW}📦 Tạo namespace...${NC}"
    kubectl apply -f k8s/namespace.yaml
    echo -e "${GREEN}✅ Namespace đã được tạo${NC}"
}

# Function to create storage
create_storage() {
    echo -e "\n${YELLOW}💾 Tạo storage...${NC}"
    kubectl apply -f k8s/storage-class.yaml
    kubectl apply -f k8s/persistent-volume.yaml
    echo -e "${GREEN}✅ Storage đã được tạo${NC}"
}

# Function to create config
create_config() {
    echo -e "\n${YELLOW}⚙️ Tạo config...${NC}"
    kubectl apply -f k8s/configmap.yaml
    echo -e "${GREEN}✅ Config đã được tạo${NC}"
}

# Function to deploy database
deploy_database() {
    echo -e "\n${YELLOW}🗄️ Deploy database...${NC}"
    kubectl apply -f k8s/rethinkdb-deployment.yaml
    echo -e "${GREEN}✅ Database đã được deploy${NC}"
}

# Function to deploy STF services
deploy_stf_services() {
    echo -e "\n${YELLOW}🔧 Deploy STF services...${NC}"
    kubectl apply -f k8s/stf-deployments.yaml
    kubectl apply -f k8s/stf-services.yaml
    echo -e "${GREEN}✅ STF services đã được deploy${NC}"
}

# Function to deploy nginx
deploy_nginx() {
    echo -e "\n${YELLOW}🌐 Deploy nginx...${NC}"
    kubectl apply -f k8s/nginx-ingress.yaml
    echo -e "${GREEN}✅ Nginx đã được deploy${NC}"
}

# Function to check deployment status
check_status() {
    echo -e "\n${YELLOW}📊 Kiểm tra trạng thái deployment...${NC}"
    
    # Check pods
    echo -e "${BLUE}Pods:${NC}"
    kubectl get pods -n stf-devicefarm
    
    # Check services
    echo -e "\n${BLUE}Services:${NC}"
    kubectl get services -n stf-devicefarm
    
    # Check persistent volumes
    echo -e "\n${BLUE}Persistent Volumes:${NC}"
    kubectl get pv,pvc -n stf-devicefarm
}

# Function to show logs
show_logs() {
    echo -e "\n${YELLOW}📋 Logs của các pods:${NC}"
    
    # Get all pods in namespace
    pods=$(kubectl get pods -n stf-devicefarm --no-headers -o custom-columns=":metadata.name")
    
    for pod in $pods; do
        echo -e "\n${BLUE}📋 Logs của $pod:${NC}"
        kubectl logs $pod -n stf-devicefarm --tail=5 2>/dev/null || echo "Không thể lấy logs của $pod"
    done
}

# Function to monitor logs in real-time
monitor_logs() {
    echo -e "\n${YELLOW}🔍 Monitoring logs real-time...${NC}"
    echo -e "${GREEN}Nhấn Ctrl+C để dừng monitoring${NC}"
    
    # Monitor all pods
    kubectl logs -f deployment/stf-auth -n stf-devicefarm &
    kubectl logs -f deployment/stf-app -n stf-devicefarm &
    kubectl logs -f deployment/stf-api -n stf-devicefarm &
    kubectl logs -f deployment/stf-websocket -n stf-devicefarm &
    kubectl logs -f deployment/stf-provider -n stf-devicefarm &
    kubectl logs -f deployment/stf-rethinkdb -n stf-devicefarm &
    
    # Wait for user to stop
    wait
}

# Function to show access information
show_access_info() {
    echo -e "\n${GREEN}🌐 Thông tin truy cập:${NC}"
    echo -e "${BLUE}STF Web Interface:${NC} http://localhost:30080"
    echo -e "${BLUE}STF Auth:${NC} http://localhost:30080/auth/mock/"
    echo -e "${BLUE}STF API:${NC} http://localhost:30080/api/"
    echo -e "${BLUE}RethinkDB Admin:${NC} http://localhost:30080 (port 8080)"
    
    echo -e "\n${YELLOW}📋 Commands hữu ích:${NC}"
    echo -e "${BLUE}Kiểm tra pods:${NC} kubectl get pods -n stf-devicefarm"
    echo -e "${BLUE}Xem logs:${NC} kubectl logs <pod-name> -n stf-devicefarm"
    echo -e "${BLUE}Exec vào pod:${NC} kubectl exec -it <pod-name> -n stf-devicefarm -- /bin/bash"
    echo -e "${BLUE}Port forward:${NC} kubectl port-forward svc/stf-nginx 8081:80 -n stf-devicefarm"
}

# Main execution
main() {
    echo -e "${GREEN}🚀 Bắt đầu deploy STF DeviceFarm lên Kubernetes...${NC}"
    
    # Check prerequisites
    check_kubectl
    
    # Deploy in order
    create_namespace
    create_storage
    create_config
    deploy_database
    
    # Wait for database to be ready
    echo -e "\n${YELLOW}⏳ Đợi database khởi động...${NC}"
    kubectl wait --for=condition=ready pod -l app=stf-rethinkdb -n stf-devicefarm --timeout=300s
    
    deploy_stf_services
    deploy_nginx
    
    # Wait for all pods to be ready
    echo -e "\n${YELLOW}⏳ Đợi tất cả services khởi động...${NC}"
    kubectl wait --for=condition=ready pod -l app=stf-auth -n stf-devicefarm --timeout=300s
    kubectl wait --for=condition=ready pod -l app=stf-app -n stf-devicefarm --timeout=300s
    kubectl wait --for=condition=ready pod -l app=stf-api -n stf-devicefarm --timeout=300s
    kubectl wait --for=condition=ready pod -l app=stf-websocket -n stf-devicefarm --timeout=300s
    kubectl wait --for=condition=ready pod -l app=stf-provider -n stf-devicefarm --timeout=300s
    kubectl wait --for=condition=ready pod -l app=stf-nginx -n stf-devicefarm --timeout=300s
    
    # Show status
    check_status
    
    # Show logs
    show_logs
    
    # Show access information
    show_access_info
    
    echo -e "\n${GREEN}✅ Deployment hoàn tất!${NC}"
    
    # Ask if user wants to monitor logs
    echo -e "\n${YELLOW}Bạn có muốn monitor logs real-time không? (y/n):${NC}"
    read -r choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        monitor_logs
    fi
}

# Run main function
main
