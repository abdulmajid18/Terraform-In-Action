resource "aws_instance" "web_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = var.instance_type
  tags = {
    Name = "terraform-example"
  }
}