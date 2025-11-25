#!/bin/bash

# --- Configuration ---
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Define all manifest files in the logical order they were applied
# Note: We delete them in reverse order, but defining them here ensures we hit every resource.
MANIFESTS=(
  08-ingress.yaml
  06-frontend-deployment.yaml
  07-frontend-svc.yaml
  04-backend-deployment.yaml
  05-backend-svc.yaml
#   02-mongodb-pvc.yaml # StatefulSet/PVC
  03-mongodb-svc.yaml
  01-secrets.yaml
)

# --- Step 1: Delete Kubernetes Resources ---
echo -e "${RED}--- 1. Deleting Application Manifests (Deployments, Services, Secrets) ---${NC}"

# We use the array to delete everything we created
for file in "${MANIFESTS[@]}"; do
  if [ -f "$file" ]; then
    echo -e "  Deleting: $file"
    # --ignore-not-found=true prevents the script from stopping if a resource was already deleted
    # --force ensures immediate termination
    kubectl delete -f "$file" --ignore-not-found=true --force
  else
    echo -e "  [SKIP] File not found: $file"
  fi
done


# --- Step 2: Final Status Check ---
echo -e "\n${GREEN}Cleanup Complete! Minikube remains running.${NC}"
echo -e "Checking remaining Pods and Services:"
kubectl get pods
kubectl get svc