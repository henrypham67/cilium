#!/bin/bash

helm upgrade cilium cilium/cilium \
   --namespace kube-system \
   --values cilium-values.yaml

kubectl -n kube-system rollout restart deployment/cilium-operator
kubectl -n kube-system rollout restart ds/cilium