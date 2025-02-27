#!/bin/bash

kubectl apply -f http-sw-app.yaml

kubectl wait --for=condition=Ready pod/tiefighter
kubectl exec tiefighter -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing

kubectl wait --for=condition=Ready pod/xwing
kubectl exec xwing -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing

