##General vars
variable "ssh_user" {
  default = "ubuntu"
}

variable "public_key_path" {
  default = "/Users/spencer/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  default = "/Users/spencer/.ssh/id_rsa"
}

##AWS Specific Vars
variable "aws_worker_count" {
  default = 1
}

variable "aws_key_name" {
  default = "spencer-key"
}

variable "aws_instance_size" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "us-west-2"
}

##GCE Specific Vars
variable "gce_worker_count" {
  default = 1
}

variable "gce_creds_path" {
  default = "/Users/spencer/gce-creds.json"
}

variable "gce_project" {
  default = "flotilla-test"
}

variable "gce_region" {
  default = "us-central1"
}

variable "gce_instance_size" {
  default = "n1-standard-1"
}
