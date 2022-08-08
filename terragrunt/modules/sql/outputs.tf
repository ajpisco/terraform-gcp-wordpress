output "instance_ip_address" {
  description = "VPC Network name"
  value       = module.sql-db_mysql.instance_ip_address[0]["ip_address"]
}