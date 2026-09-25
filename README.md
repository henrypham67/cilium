# Cilium labs — KinD and EKS

Hands-on Cilium, from a laptop cluster to AWS: install on KinD, L3/L4 and L7
`CiliumNetworkPolicy`, Cilium as ingress controller / service mesh, and an EKS
cluster running Cilium as the CNI, provisioned with Terraform and bootstrapped
with FluxCD.

## Layout

| Path | What it holds |
| --- | --- |
| `01-install/` | KinD config, Cilium Helm values, install script |
| `02-network-policies/` | Demo app, L3/L4 and L7 policies, step-by-step scripts to create pods, test requests and apply each policy |
| `service-mesh/ingress/` | Cilium ingress controller values and run script |
| `eks/` | Terraform: EKS with Cilium CNI, Cluster API IAM, FluxCD bootstrap |

## Quick start (KinD)

```bash
cd 01-install && ./run.sh
cd ../02-network-policies
./01-create-pods-and-test-request.sh
./02-apply-l3-l4-policies.sh
./03-apply-l7-policies.sh
```

## EKS

```bash
cd eks && make   # see the Makefile for init/plan/apply/destroy targets
```

## Open items

- Cluster API bootstrap (`clusterawsadm`), SSH key and AWS credential handling for the EKS path are still being tested.

## Reference

- [Cilium ClusterMesh on EKS](https://docs.cilium.io/en/latest/network/clustermesh/eks-clustermesh-prep/)
