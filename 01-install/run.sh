#!/bin/bash

kind create cluster --config kind-config.yaml 

docker pull quay.io/cilium/cilium:v1.17.1
kind load docker-image quay.io/cilium/cilium:v1.17.1

helm install cilium cilium/cilium --version 1.17.1 \
   --namespace kube-system \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes \
   --values cilium-values.yaml

echo "Access Hubble UI: http://localhost:31235/"