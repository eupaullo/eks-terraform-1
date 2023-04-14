module "external_dns" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-external-dns.git"

#   cluster_name                     = "my-test-eks" 
#   cluster_identity_oidc_issuer     = "https://oidc.eks.us-west-1.amazonaws.com/id/4057BAC386A74E29F4A98C09BE08248F" 
#   cluster_identity_oidc_issuer_arn = "arn:aws:iam::274813024103:oidc-provider/oidc.eks.us-west-1.amazonaws.com/id/4057BAC386A74E29F4A98C09BE08248F" 

  cluster_name                     = data.aws_eks_cluster.default.name #module.eks_cluster.cluster_id
  cluster_identity_oidc_issuer     = data.aws_eks_cluster.default.identity[0].oidc[0].issuer #module.eks_cluster.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = data.aws_iam_openid_connect_provider.default.arn #module.eks_cluster.oidc_provider_arn

  settings = {
    "policy" = "sync" # Modify how DNS records are sychronized between sources and providers.
  }
}

# data "terraform_remote_state" "oidc_arn" {
#   backend = "local"

#   config = {
#     path = "./terraform.tfstate"
#   }
# }

# locals {
#   oidc_arn = data.terraform_remote_state.aws_iam_openid_connect_provider.oidc[0].arn
# }

# aws_iam_openid_connect_provider.default.arn
# aws_eks_cluster.this[0].identity[0].oidc[0].issuer
# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "18.31.2"
#   #version = "18.29.0"

#   cluster_name    = "my-test-eks"
#   cluster_version = "1.26"

#   cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   enable_irsa = true
# }
# data "aws_eks_cluster" "default" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "default" {
#   name = module.eks.cluster_id
# }

#count = alltrue([var.create_cluster, var.create_eks_addons]) ? 1 : 0
# module "eks" {
#     source = "./modules/eks"
#     cluster_name = local.cluster_name
#     subnet_ids = module.vpc.private_subnets
#     vpc_id = module.vpc.vpc_id
#     instance_type_nodes = var.instance_type_nodes
#     desired_nodes = var.desired_nodes
#     eks_userarn = local.eks_userarn
#     eks_username = local.eks_username
#     tags = local.common_tags
# }
