output "eks_cluster" {
  value = aws_eks_cluster.eks-cluster-test
  
}

output "security_group" {
  value = aws_security_group.cluster_master_sg
}