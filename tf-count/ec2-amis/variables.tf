variable "ec2-config" {
  type = list(object({
    ami = string
    instance_type = string
  }))
}