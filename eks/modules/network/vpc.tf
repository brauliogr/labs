resource "aws_vpc" "vpc-01be47c3c04744fbf" {
    cidr_block = "10.100.0.0/16"

    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "vpc-cluster-test-sa-east-1"
    }

  
}
