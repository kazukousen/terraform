provider "aws" {
  region = "ap-northeast-1"
}

variable env {
  default = "dev"
}

module "dev_server" {
  source        = "./http_server"
  instance_type = var.env == "prod" ? "t3.large" : "t3.micro"
}

output "public_dns" {
  value = module.dev_server.public_dns
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions"]
    resources = ["*"]
  }
}

module "describe_regions_for_ec2" {
  source     = "./iam_role"
  name       = "describe-regions-for-ec2"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.allow_describe_regions.json
}

module "s3" {
  source = "./storage"
}

module "network" {
  source = "./network"
}
