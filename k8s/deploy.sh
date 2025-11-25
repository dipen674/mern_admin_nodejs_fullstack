#!/bin/bash

# --- Configuration ---
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Step 0: Setup and Cleanup ---
echo -e "${YELLOW}--- 0. Starting Setup and Cleanup ---${NC}"

# Ensure Ingress is enabled ( idempotent)
if minikube addons list | grep ingress | grep -q 'disabled'; then
    echo "Enabling Minikube Ingress Addon..."
    minikube addons enable ingress
else
    echo "Minikube Ingress Addon is already enabled."
fi

# --- Step 1: Configuration and Storage Layer ---
echo -e "${YELLOW}--- 1. Applying Configuration and Database Layer (Secrets, PVC, SVC) ---${NC}"
kubectl apply -f 01-secrets.yaml
kubectl apply -f 03-mongodb-svc.yaml  # Service must exist before StatefulSet
kubectl apply -f 02-mongodb-pvc.yaml   # Creates the MongoDB StatefulSet and PVC

# --- Step 2: WAIT FOR MONGODB ---
echo -e "\n${YELLOW}--- 2. Waiting for MongoDB Pod to be Ready (Max 5 minutes) ---${NC}"
kubectl wait --for=condition=Ready pod/mongodb-0 --timeout=300s

if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: MongoDB pod did not become ready. Exiting deployment.${NC}"
    exit 1
fi
echo -e "${GREEN}SUCCESS: MongoDB is Ready.${NC}"

# --- Step 3: Application Services Layer ---
echo -e "\n${YELLOW}--- 3. Applying Application Services (Backend & Frontend) ---${NC}"
kubectl apply -f 05-backend-svc.yaml
kubectl apply -f 07-frontend-svc.yaml

# --- Step 4: Application Deployment Layer ---
echo -e "\n${YELLOW}--- 4. Applying Deployments (Backend & Frontend) ---${NC}"
kubectl apply -f 04-backend-deployment.yaml
kubectl apply -f 06-frontend-deployment.yaml

# --- Step 5: External Exposure ---
echo -e "\n${YELLOW}--- 5. Applying Ingress Route ---${NC}"
kubectl apply -f 08-ingress.yaml

# --- Step 6: Final Verification ---
echo -e "\n${YELLOW}--- 6. Final Status and Access Information ---${NC}"
echo -e "Deployed Resources:"
kubectl get all,pvc,ingress

echo -e "\n${GREEN}Deployment Complete!${NC}"
echo -e "${GREEN}ACCESS INSTRUCTIONS:${NC}"
echo "Find your Minikube IP below and open your browser:"
minikube ip
echo "The application should be accessible at: http://<MINIKUBE-IP>/"