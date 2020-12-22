output "iam_profile" {
  value = aws_iam_instance_profile.main.id
}

output "iam_role" {
  value = aws_iam_role.main.arn
}

output "instance_profiles" {
  value = {
    default      = aws_iam_instance_profile.main.id
    landing_zone = aws_iam_instance_profile.landing_zone.id
  }
}

output "iam_roles" {
  value = {
    default      = aws_iam_role.main
    landing_zone = aws_iam_role.landing_zone
  }
}
