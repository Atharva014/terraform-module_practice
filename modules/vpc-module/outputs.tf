output "ath_vpc_id" {
  value = aws_vpc.atharva_vpc.id
}

output "ath_web_sub_id" {
  value = aws_subnet.atharva_vpc_web_public_sub[*].id
}

output "ath_app_sub_id" {
  value = aws_subnet.atharva_vpc_app_private_sub[*].id
}

output "ath_db_sub_id" {
  value = aws_subnet.atharva_vpc_db_private_sub[*].id
}

output "ath_web_instance_id" {
  value = aws_instance.public_web_srv[*].id
}

output "ath_app_instance_id" {
  value = aws_instance.private_app_srv[*].id
}

output "ath_db_instance_id" {
  value = aws_instance.private_db_srv[*].id
}