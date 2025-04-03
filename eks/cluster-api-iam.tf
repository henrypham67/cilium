
resource "aws_iam_instance_profile" "aws_iam_instance_profile_control_plane" {
  name = "control-plane.cluster-api-provider-aws.sigs.k8s.io"
  role = aws_iam_role.aws_iam_role_control_plane.name
}

resource "aws_iam_instance_profile" "aws_iam_instance_profile_controllers" {
  name = "controllers.cluster-api-provider-aws.sigs.k8s.io"
  role = aws_iam_role.aws_iam_role_controllers.name
}

resource "aws_iam_instance_profile" "aws_iam_instance_profile_nodes" {
  name = "nodes.cluster-api-provider-aws.sigs.k8s.io"
  role = aws_iam_role.aws_iam_role_nodes.name
}

resource "aws_iam_policy" "aws_iam_managed_policy_cloud_provider_control_plane" {
  description = "For the Kubernetes Cloud Provider AWS Control Plane"
  name        = "control-plane.cluster-api-provider-aws.sigs.k8s.io"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:AssignIpv6Addresses",
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DescribeVpcs",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:AttachLoadBalancerToSubnets",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancerListeners",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DetachLoadBalancerFromSubnets",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
          "iam:CreateServiceLinkedRole",
          "kms:DescribeKey"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "aws_iam_managed_policy_cloud_provider_nodes" {
  description = "For the Kubernetes Cloud Provider AWS nodes"
  name        = "nodes.cluster-api-provider-aws.sigs.k8s.io"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ec2:AssignIpv6Addresses",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:CreateTags",
          "ec2:DescribeTags",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeInstanceTypes",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "secretsmanager:DeleteSecret",
          "secretsmanager:GetSecretValue"
        ]
        Effect = "Allow"
        Resource = [
          "arn:*:secretsmanager:*:*:secret:aws.cluster.x-k8s.io/*"
        ]
      },
      {
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "s3:GetEncryptionConfiguration"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "aws_iam_managed_policy_controllers" {
  description = "For the Kubernetes Cluster API Provider AWS Controllers"
  name        = "controllers.cluster-api-provider-aws.sigs.k8s.io"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ec2:DescribeIpamPools",
          "ec2:AllocateIpamPoolCidr",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface",
          "ec2:AllocateAddress",
          "ec2:AssignIpv6Addresses",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses",
          "ec2:AssociateRouteTable",
          "ec2:AssociateVpcCidrBlock",
          "ec2:AttachInternetGateway",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateCarrierGateway",
          "ec2:CreateInternetGateway",
          "ec2:CreateEgressOnlyInternetGateway",
          "ec2:CreateNatGateway",
          "ec2:CreateNetworkInterface",
          "ec2:CreateRoute",
          "ec2:CreateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSubnet",
          "ec2:CreateTags",
          "ec2:CreateVpc",
          "ec2:CreateVpcEndpoint",
          "ec2:DisassociateVpcCidrBlock",
          "ec2:ModifyVpcAttribute",
          "ec2:ModifyVpcEndpoint",
          "ec2:DeleteCarrierGateway",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteEgressOnlyInternetGateway",
          "ec2:DeleteNatGateway",
          "ec2:DeleteRouteTable",
          "ec2:ReplaceRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSubnet",
          "ec2:DeleteTags",
          "ec2:DeleteVpc",
          "ec2:DeleteVpcEndpoints",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeCarrierGateways",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeEgressOnlyInternetGateways",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeImages",
          "ec2:DescribeNatGateways",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeNetworkInterfaceAttribute",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:DetachInternetGateway",
          "ec2:DisassociateRouteTable",
          "ec2:DisassociateAddress",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:ModifySubnetAttribute",
          "ec2:ReleaseAddress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "tag:GetResources",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:RemoveTags",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeleteListener",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeInstanceRefreshes",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteLaunchTemplateVersions",
          "ec2:DescribeKeyPairs",
          "ec2:ModifyInstanceMetadataOptions"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:CreateOrUpdateTags",
          "autoscaling:StartInstanceRefresh",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:DeleteTags"
        ]
        Effect = "Allow"
        Resource = [
          "arn:*:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/*"
        ]
      },
      {
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = "autoscaling.amazonaws.com"
          }
        }
        Effect = "Allow"
        Resource = [
          "arn:*:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        ]
      },
      {
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = "elasticloadbalancing.amazonaws.com"
          }
        }
        Effect = "Allow"
        Resource = [
          "arn:*:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing"
        ]
      },
      {
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = "spot.amazonaws.com"
          }
        }
        Effect = "Allow"
        Resource = [
          "arn:*:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot"
        ]
      },
      {
        Action = [
          "iam:PassRole"
        ]
        Effect = "Allow"
        Resource = [
          "arn:*:iam::*:role/*.cluster-api-provider-aws.sigs.k8s.io"
        ]
      },
      {
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:TagResource"
        ]
        Effect = "Allow"
        Resource = [
          "arn:*:secretsmanager:*:*:secret:aws.cluster.x-k8s.io/*"
        ]
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "aws_iam_managed_policy_controllers_eks" {
  description = "For the Kubernetes Cluster API Provider AWS Controllers"
  name        = "controllers-eks.cluster-api-provider-aws.sigs.k8s.io"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ssm:GetParameter"
        ]
        Effect = "Allow"
        Resource = [
          "arn:*:ssm:*:*:parameter/aws/service/eks/optimized-ami/*"
        ]
      },
      {
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = "eks.amazonaws.com"
          }
        }
        Effect = "Allow"
        Resource = [
          "arn:*:iam::*:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
        ]
      },
      {
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = "eks-nodegroup.amazonaws.com"
          }
        }
        Effect = "Allow"
        Resource = [
          "arn:*:iam::*:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"
        ]
      },
      {
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Condition = {
          StringLike = {
            "iam:AWSServiceName" = "eks-fargate.amazonaws.com"
          }
        }
        Effect = "Allow"
        Resource = [
          "arn:aws:iam::*:role/aws-service-role/eks-fargate-pods.amazonaws.com/AWSServiceRoleForAmazonEKSForFargate"
        ]
      },
      {
        Action = [
          "iam:ListOpenIDConnectProviders",
          "iam:GetOpenIDConnectProvider",
          "iam:CreateOpenIDConnectProvider",
          "iam:AddClientIDToOpenIDConnectProvider",
          "iam:UpdateOpenIDConnectProviderThumbprint",
          "iam:DeleteOpenIDConnectProvider",
          "iam:TagOpenIDConnectProvider"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:DetachRolePolicy",
          "iam:DeleteRole",
          "iam:CreateRole",
          "iam:TagRole",
          "iam:AttachRolePolicy"
        ]
        Effect = "Allow"
        Resource = [
          "arn:*:iam::*:role/*"
        ]
      },
      {
        Action = [
          "iam:GetPolicy"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        ]
      },
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:CreateCluster",
          "eks:TagResource",
          "eks:UpdateClusterVersion",
          "eks:DeleteCluster",
          "eks:UpdateClusterConfig",
          "eks:UntagResource",
          "eks:UpdateNodegroupVersion",
          "eks:DescribeNodegroup",
          "eks:DeleteNodegroup",
          "eks:UpdateNodegroupConfig",
          "eks:CreateNodegroup",
          "eks:AssociateEncryptionConfig",
          "eks:ListIdentityProviderConfigs",
          "eks:AssociateIdentityProviderConfig",
          "eks:DescribeIdentityProviderConfig",
          "eks:DisassociateIdentityProviderConfig"
        ]
        Effect = "Allow"
        Resource = [
          "arn:*:eks:*:*:cluster/*",
          "arn:*:eks:*:*:nodegroup/*/*/*"
        ]
      },
      {
        Action = [
          "ec2:AssociateVpcCidrBlock",
          "ec2:DisassociateVpcCidrBlock",
          "eks:ListAddons",
          "eks:CreateAddon",
          "eks:DescribeAddonVersions",
          "eks:DescribeAddon",
          "eks:DeleteAddon",
          "eks:UpdateAddon",
          "eks:TagResource",
          "eks:DescribeFargateProfile",
          "eks:CreateFargateProfile",
          "eks:DeleteFargateProfile"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "iam:PassRole"
        ]
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "eks.amazonaws.com"
          }
        }
        Effect = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "kms:CreateGrant",
          "kms:DescribeKey"
        ]
        Condition = {
          "ForAnyValue:StringLike" = {
            "kms:ResourceAliases" = "alias/cluster-api-provider-aws-*"
          }
        }
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
    Version = "2012-10-17"
  })

}

resource "aws_iam_role" "aws_iam_role_control_plane" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
    Version = "2012-10-17"
  })
  name = "control-plane.cluster-api-provider-aws.sigs.k8s.io"
}

resource "aws_iam_role" "aws_iam_role_controllers" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
    Version = "2012-10-17"
  })
  name = "controllers.cluster-api-provider-aws.sigs.k8s.io"
}

resource "aws_iam_role" "aws_iam_role_eks_control_plane" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = [
            "eks.amazonaws.com"
          ]
        }
      }
    ]
    Version = "2012-10-17"
  })
  name = "eks-controlplane.cluster-api-provider-aws.sigs.k8s.io"
}

resource "aws_iam_role_policy_attachment" "control-plane" {
  role       = aws_iam_role.aws_iam_role_eks_control_plane.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "aws_iam_role_eks_nodegroup" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "eks.amazonaws.com"
          ]
        }
      }
    ]
    Version = "2012-10-17"
  })
  name = "eks-nodegroup.cluster-api-provider-aws.sigs.k8s.io"
}

resource "aws_iam_role_policy_attachment" "cp-worker" {
  role       = aws_iam_role.aws_iam_role_eks_control_plane.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cp-cni" {
  role       = aws_iam_role.aws_iam_role_eks_control_plane.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "cp-ecr" {
  role       = aws_iam_role.aws_iam_role_eks_control_plane.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role" "aws_iam_role_nodes" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
    Version = "2012-10-17"
  })
  name = "nodes.cluster-api-provider-aws.sigs.k8s.io"
}
resource "aws_iam_role_policy_attachment" "node-worker" {
  role       = aws_iam_role.aws_iam_role_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node-cni" {
  role       = aws_iam_role.aws_iam_role_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node-ecr" {
  role       = aws_iam_role.aws_iam_role_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}