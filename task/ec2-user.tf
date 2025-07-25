resource "aws_instance" "tf-instance" {
  ami = "ami-09278528675a8d54e"
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.name.id
  security_groups = [ data.aws_security_group.name.id ]
  tags = {
    Name = "tf-instance"
  }
}