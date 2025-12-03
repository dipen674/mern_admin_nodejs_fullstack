#!/bin/bash

MANIFESTS=(
  ingress.yaml
  frontend-deployment.yaml
  frontend-svc.yaml
  backend-deployment.yaml
  backend-svc.yaml
  mongodb-pvc.yaml 
  mongodb-svc.yaml
  secrets.yaml
)

echo "--- 1. Deleting Application Manifests (Ingress, Deployments, Services, PVCs, Secrets) ---"

for file in "${MANIFESTS[@]}"; do
  if [ -f "$file" ]; then
    echo "  Deleting: $file"
    kubectl delete -f "$file" --ignore-not-found=true --force
  else
    echo "  [SKIP] File not found: $file"
  fi
done


echo ""
echo "--- 2. Disabling Minikube Ingress Addon ---"

if minikube addons list | grep 'ingress' | grep -q 'enabled'; then
    echo "Disabling Minikube Ingress Addon..."
    minikube addons disable ingress
else
    echo "Minikube Ingress Addon is already disabled."
fi


echo ""
echo "--- 3. Cleanup Complete! ---"


echo "Checking remaining Kubernetes resources for confirmation:"
echo "  Remaining Pods:"

kubectl get pods --field-selector=status.phase!=Succeeded

echo ""
echo "  Remaining Services:"

kubectl get svc | grep -v 'kubernetes' | grep -v 'kube-dns' | grep -v 'metrics-server'

echo ""
echo "All application resources defined in the manifest files have been targeted for deletion."