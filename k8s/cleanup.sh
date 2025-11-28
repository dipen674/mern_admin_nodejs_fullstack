#!/bin/bash

# --- Define Manifests ---
# Define all manifest files in the logical order they were applied.
# Note: Files are DELETED in this array's order.
MANIFESTS=(
  ingress.yaml
  frontend-deployment.yaml
  frontend-svc.yaml
  backend-deployment.yaml
  backend-svc.yaml
  mongodb-pvc.yaml  # Note: This will delete the PVC, potentially losing data. Remove if retaining data.
  mongodb-svc.yaml
  secrets.yaml
)

# --- Step 1: Delete Kubernetes Resources ---
echo "--- 1. Deleting Application Manifests (Ingress, Deployments, Services, PVCs, Secrets) ---"

# Iterate and delete
for file in "${MANIFESTS[@]}"; do
  if [ -f "$file" ]; then
    echo "  Deleting: $file"
    # --ignore-not-found=true prevents script failure
    # --force ensures immediate termination
    kubectl delete -f "$file" --ignore-not-found=true --force
  else
    echo "  [SKIP] File not found: $file"
  fi
done

# --- Step 2: Cleanup Minikube Addons (Optional but thorough) ---
echo ""
echo "--- 2. Disabling Minikube Ingress Addon ---"
# Check if ingress is enabled by searching the output of minikube addons list
if minikube addons list | grep 'ingress' | grep -q 'enabled'; then
    echo "Disabling Minikube Ingress Addon..."
    minikube addons disable ingress
else
    echo "Minikube Ingress Addon is already disabled."
fi


# --- Step 3: Final Status Check ---
echo ""
echo "--- 3. Cleanup Complete! ---"

# Check for remaining application resources
echo "Checking remaining Kubernetes resources for confirmation:"
echo "  Remaining Pods:"
# Show only running or pending pods
kubectl get pods --field-selector=status.phase!=Succeeded

echo ""
echo "  Remaining Services:"
# Filter out standard Kubernetes services
kubectl get svc | grep -v 'kubernetes' | grep -v 'kube-dns' | grep -v 'metrics-server'

echo ""
echo "All application resources defined in the manifest files have been targeted for deletion."