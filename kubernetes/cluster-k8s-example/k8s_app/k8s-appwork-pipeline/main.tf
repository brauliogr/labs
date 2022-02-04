provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/braulio/.aws/credentials"
  profile = "terraform"

}

resource "aws_instance" "k8s-master" {
  ami = "ami-0c43b23f011ba5061"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.my-key.key_name}"
  count = 1
  security_groups = ["${aws_security_group.k8s-sg.name}"]

 tags = {
    name = "k8s"
    type = "master"

  } 

}

resource "aws_instance" "k8s-node" {
  ami = "ami-0c43b23f011ba5061"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.my-key.key_name}"
  count = 2
  security_groups = ["${aws_security_group.k8s-sg.name}"]

 tags = {
    name = "k8s"
    type = "node"
  } 

}

resource "aws_key_pair" "my-key" {
  key_name = "my-key"
  public_key = "${file("/home/ubuntu/id_rsa.pub")}"

}

resource "aws_security_group" "k8s-sg" {


ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

 }
  

  ingress {
    from_port = 30000
    to_port = 30000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

 } 

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

 } 

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

 } 


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }

}
