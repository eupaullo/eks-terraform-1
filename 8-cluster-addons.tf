resource "aws_eks_addon" "kube_proxy" {
  count = alltrue([var.create_cluster, var.create_eks_addons]) ? 1 : 0

  cluster_name      = data.aws_eks_cluster.default.name
  addon_name        = "kube-proxy"
  addon_version     = var.eks_addon_version_kube_proxy
  resolve_conflicts = "OVERWRITE"

  preserve = true

  tags = merge(
    var.tags,
    {
      "eks_addon" = "kube-proxy"
    }
  )
}

resource "aws_eks_addon" "core_dns" {
  count = alltrue([var.create_cluster, var.create_eks_addons]) ? 1 : 0

  cluster_name      = data.aws_eks_cluster.default.name
  addon_name        = "coredns"
  addon_version     = var.eks_addon_version_core_dns
  resolve_conflicts = "OVERWRITE"

  preserve = true

  tags = merge(
    var.tags,
    {
      "eks_addon" = "coredns"
    }
  )
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  count = alltrue([var.create_cluster, var.create_eks_addons]) ? 1 : 0

  cluster_name      = data.aws_eks_cluster.default.name
  addon_name        = "aws-ebs-csi-driver"
  addon_version     = var.eks_addon_version_ebs_csi_driver
  resolve_conflicts = "OVERWRITE"

  #service_account_role_arn = aws_iam_role.ebs_csi_controller_sa[0].arn

  preserve = false

  tags = merge(
    var.tags,
    {
      "eks_addon" = "ebs-csi-driver"
    }
  )
}

resource "aws_eks_addon" "vpc_cni" {
  count = alltrue([var.create_cluster, var.create_eks_addons]) ? 1 : 0
  #count = var.addon_create_vpc_cni ? 1 : 0

  cluster_name      = data.aws_eks_cluster.default.name
  addon_name        = "vpc-cni"
  resolve_conflicts = "OVERWRITE"
  addon_version     = var.eks_addon_version_vpc_cni
  #service_account_role_arn = module.irsa_vpc_cni.iam_role_arn

  lifecycle {
    ignore_changes = [cluster_name, addon_name]
  }
  tags = merge(
    var.tags,
    {
      "eks_addon" = "vpc-cni"
    }
  )
}

# resource "aws_iam_role" "ebs_csi_controller_sa" {
#   count = alltrue([var.create_cluster, var.create_eks_addons]) ? 1 : 0

#   name = "ebs-csi-controller-sa"

#   assume_role_policy = templatefile("policies/oidc_assume_role_policy.json", {
#     OIDC_ARN  = aws_iam_openid_connect_provider.cluster[0].arn,
#     OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster[0].url, "https://", ""),
#     NAMESPACE = "kube-system",
#     SA_NAME   = "ebs-csi-controller-sa"
#   })

#   managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
# }

# resource "aws_eks_addon" "kubecost" {
#   count = alltrue([var.create_cluster, var.create_eks_addons]) ? 1 : 0

#   cluster_name      = data.aws_eks_cluster.default.name
#   addon_name        = "kubecost_kubecost"
#   addon_version     = var.eks_addon_version_kubecost
#   resolve_conflicts = "OVERWRITE"

#   preserve = true

#   tags = merge(
#     var.tags,
#     {
#       "eks_addon" = "kubecost"
#     }
#   )
# }