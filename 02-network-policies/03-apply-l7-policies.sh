#!/bin/bash

echo "Before apply network policy"

kubectl exec tiefighter -- curl -s -XPUT deathstar.default.svc.cluster.local/v1/exhaust-port
echo "This should not be happening"

echo "Applying network policy"
kubectl apply -f cilium-l7-policy.yaml

echo "After apply network policy"

kubectl exec tiefighter -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
kubectl exec tiefighter -- curl -s -XPUT deathstar.default.svc.cluster.local/v1/exhaust-port

kubectl describe ciliumnetworkpolicies
