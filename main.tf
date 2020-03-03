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
