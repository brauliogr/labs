// Exportando os recursos a serem utilizado pelos outros modulos
output "vpc-01be47c3c04744fbf" {
    value =  aws_vpc.vpc-01be47c3c04744fbf
  
}

output "subnet-private-cluster-test-eks-1a" {
    value = aws_subnet.subnet-private-cluster-test-eks-1a
  
}

output "subnet-private-cluster-test-eks-1c" {
    value = aws_subnet.subnet-private-cluster-test-eks-1c
  
}

output "subnet-public-cluster-test-eks-1a" {
    value = aws_subnet.subnet-public-cluster-test-eks-1a
  
}

output "subnet-public-cluster-test-eks-1c" {
    value = aws_subnet.subnet-public-cluster-test-eks-1c
  
}
