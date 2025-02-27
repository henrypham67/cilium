#!/bin/bash

echo "Before apply network policy for deadstar"
kubectl -n kube-system exec cilium-1c2cz -- cilium-dbg endpoint list
if [ $? -eq 1 ]; then
  >&2 echo "Please update Cilium's Pod name before and after apply policy in this script"
  exit 1
fi

kubectl apply -f cilium-l4-policy.yaml

kubectl exec tiefighter -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing

kubectl exec xwing -- curl -s -XPOST --connect-timeout 5 deathstar.default.svc.cluster.local/v1/request-landing

if [[ $? -eq 28 ]]; then
    echo "Connection timeout"
fi

echo "After apply network policy for deadstar"
kubectl -n kube-system exec cilium-1c2cz -- cilium-dbg endpoint list

kubectl get cnp
kubectl describe cnp rule1
