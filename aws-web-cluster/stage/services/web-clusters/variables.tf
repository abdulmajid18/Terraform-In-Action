variable "aws_access_key" {
  type        = string
  description = "AWS Access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region to use for resource"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instnace"
  default     = "t2.micro"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}