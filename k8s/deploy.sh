#!/bin/bash

# --- Step 0: Setup and Cleanup ---
echo "--- 0. Starting Setup and Cleanup ---"

# Ensure Ingress is enabled (idempotent)
if minikube addons list | grep ingress | grep -q 'disabled'; then
    echo "Enabling Minikube Ingress Addon..."
    minikube addons enable ingress
else
    echo "Minikube Ingress Addon is already enabled."
fi

# --- Step 1: Configuration and Storage Layer ---
echo "--- 1. Applying Configuration and Database Layer (Secrets, PVC, SVC) ---"
kubectl apply -f secrets.yaml
kubectl apply -f mongodb-svc.yaml  # Service must exist before StatefulSet
kubectl apply -f mongodb-pvc.yaml   # Creates the MongoDB StatefulSet and PVC

# --- Step 2: WAIT FOR MONGODB ---
echo ""
echo "--- 2. Waiting for MongoDB Pod to be Ready (Max 5 minutes) ---"
kubectl wait --for=condition=Ready pod/mongodb-0 --timeout=300s

if [ $? -ne 0 ]; then
    echo "ERROR: MongoDB pod did not become ready. Exiting deployment."
    exit 1
fi
echo "SUCCESS: MongoDB is Ready."

# --- Step 3: Application Services Layer ---
echo ""
echo "--- 3. Applying Application Services (Backend & Frontend) ---"
kubectl apply -f backend-svc.yaml
kubectl apply -f frontend-svc.yaml

# --- Step 4: Application Deployment Layer ---
echo ""
echo "--- 4. Applying Deployments (Backend & Frontend) ---"
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml

# --- Step 5: External Exposure ---
echo ""
echo "--- 5. Applying Ingress Route ---"
kubectl apply -f ingress.yaml

# --- Step 6: Final Verification ---
echo ""
echo "--- 6. Final Status and Access Information ---"
echo "Deployed Resources:"
kubectl get all,pvc,ingress

echo ""
echo "Deployment Complete!"
echo "ACCESS INSTRUCTIONS:"
echo "Find your Minikube IP below and open your browser:"
minikube ip
echo "The application should be accessible at: http://<MINIKUBE-IP>/"