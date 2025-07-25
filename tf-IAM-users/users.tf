locals {
  user_data = yamldecode(file("./users.yaml")).users

  user_role_pair = flatten([for user in local.user_data: [for role in user.roles: {
    user = user.username
    role = role
  }]])
}
output "usre-roles" {
  value = local.user_role_pair
}
output "name" {
  value = local.user_data[*].username
}
#Creating users
resource "aws_iam_user" "users" {
  for_each = toset(local.user_data[*].username)
  name = each.value
}
#Password Creation
resource "aws_iam_user_login_profile" "profile" {
  for_each = aws_iam_user.users
  user = each.value.name
  password_length = 12

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}
#Attaching Policy
resource "aws_iam_user_policy_attachment" "user-policy" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.user}-${pair.role}" => pair
  }

  user = aws_iam_user.users[each.value.user].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}