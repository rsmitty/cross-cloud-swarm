##Amazon Infrastructure
provider "aws" {
  region = "${var.aws_region}"
}

##Create swarm security group
resource "aws_security_group" "swarm_sg" {
  name        = "swarm_sg"
  description = "Allow all inbound traffic necessary for Swarm"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    Name = "swarm_sg"
  }
}

##Find latest Ubuntu 16.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

##Create Swarm Master Instance
resource "aws_instance" "swarm-master" {
  depends_on             = ["aws_security_group.swarm_sg"]
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.aws_instance_size}"
  vpc_security_group_ids = ["${aws_security_group.swarm_sg.id}"]
  key_name               = "${var.aws_key_name}"

  tags {
    Name = "swarm-master"
  }
}

##Create AWS Swarm Workers
resource "aws_instance" "aws-swarm-members" {
  depends_on             = ["aws_security_group.swarm_sg"]
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.aws_instance_size}"
  vpc_security_group_ids = ["${aws_security_group.swarm_sg.id}"]
  key_name               = "${var.aws_key_name}"
  count                  = "${var.aws_worker_count}"

  tags {
    Name = "swarm-member-${count.index}"
  }
}
