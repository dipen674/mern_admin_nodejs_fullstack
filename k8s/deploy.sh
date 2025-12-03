#!/bin/bash

echo "--- 0. Starting Setup and Cleanup ---"

if minikube addons list | grep ingress | grep -q 'disabled'; then
    echo "Enabling Minikube Ingress Addon..."
    minikube addons enable ingress
else
    echo "Minikube Ingress Addon is already enabled."
fi

echo "--- 1. Applying Configuration and Database Layer (Secrets, PVC, SVC) ---"
kubectl apply -f secrets.yaml
kubectl apply -f mongodb-svc.yaml  
kubectl apply -f mongodb-pvc.yaml   

echo ""
echo "--- 2. Waiting for MongoDB Pod to be Ready (Max 5 minutes) ---"
kubectl wait --for=condition=Ready pod/mongodb-0 --timeout=300s

if [ $? -ne 0 ]; then
    echo "ERROR: MongoDB pod did not become ready. Exiting deployment."
    exit 1
fi
echo "SUCCESS: MongoDB is Ready."

echo ""
echo "--- 3. Applying Application Services (Backend & Frontend) ---"
kubectl apply -f backend-svc.yaml
kubectl apply -f frontend-svc.yaml

echo ""
echo "--- 4. Applying Deployments (Backend & Frontend) ---"
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml

echo ""
echo "--- 5. Applying Ingress Route ---"
kubectl apply -f ingress.yaml

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