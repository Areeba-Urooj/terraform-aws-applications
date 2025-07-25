terraform {}
variable "list_number" {
  type = list(list_number)
  default = [ 1,2,3,4,5 ]
}
variable "list_object" {
  type = list(object({
    fname = string
    lname = string
  }))
  default = [ {
    fname = "A"
    lname = "a"
  }, {
    fname = "B"
    lname = "b"
  } ]
}
variable "map-info" {
  type = map(number)
  default = {
    "one" = 1
    "two" = 2
    "three" = 3
  }
}
#calculations
locals {
  mul = 2*2
  add = 2+2
  equal = 2!=3
  #double the list
  double = [ for num in var.list_number: num*2 ]
  even = [ for num in var.list_number: num if num%2 == 0 ]
  fname = [ for name in var.list_object: name.fname]
  map = [for key, value in var.map-info: value*5]
}
output "operators" {
  value = local.add
}