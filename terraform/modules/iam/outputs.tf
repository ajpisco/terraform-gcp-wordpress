output "sa_email" {
  description = "Service account email"
  value       = google_service_account.wordpress_sa.email
}