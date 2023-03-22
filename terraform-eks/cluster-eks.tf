# Create EKS Cluster

resource "aws_eks_cluster" "eks-cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.exam-project-sg.id]
    subnet_ids = [aws_subnet.public-subnet-01.id, aws_subnet.public-subnet-02.id, aws_subnet.private-subnet-01.id, aws_subnet.private-subnet-02.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}

# Create EKS Cluster node group

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "ep-eks-node-group"
  node_role_arn   = aws_iam_role.eks-nodes-role.arn
  instance_types = ["t2.medium"]
  subnet_ids      = [aws_subnet.public-subnet-01.id, aws_subnet.public-subnet-02.id, aws_subnet.private-subnet-01.id, aws_subnet.private-subnet-02.id]

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}


# CloudWatch Log group for EKS cluster

resource "aws_cloudwatch_log_group" "eks-cluster-logs" {
  name              = "/aws/eks/eks-cluster/cluster"
  retention_in_days = 7
}
