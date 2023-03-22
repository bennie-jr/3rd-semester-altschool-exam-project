provider "aws" {
  region     = "us-east-1"
}

# Kubectl Terraform provider

terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket = "tf-state-v1.0"
    key = "global/infrastructure/terraform.tfstate"
    region     = "us-east-1"
    dynamodb_table = "tf-statefile-lock"
    encrypt = true
  }
}

#provider "kubernetes" {
#  config_context_cluster = "examproject-eks-${random_string.suffix.result}"
#  config_path        = "$HOME/.kube/config"
#}



provider "kubectl" {
  host                   = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks-cluster.name]
    command     = "aws"
  }
}




provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster.name]
    command     = "aws"
  }
}
