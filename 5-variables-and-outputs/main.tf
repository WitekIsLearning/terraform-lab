terraform {

}
variable "instance_type" {
  type = string
  description = "The size of VM"
  # sensitive = true
  validation {
    condition     = can(regex("^t2.",var.instance_type))
    error_message = "The instance must be a t2 type"
	}
}

module "aws_server" {
    source = ".//aws_server"
    instance_type = var.instance_type
}

output "public_ip" {
  value = module.aws_server.public_ip
  sensitive = false
}