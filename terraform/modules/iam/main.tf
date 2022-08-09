resource "google_service_account" "wordpress_sa" {
  account_id   = var.sa_account_id
  display_name = "Service Account to be used by WordPress server"
}

# resource "google_project_iam_custom_role" "wordpress_custom_role" {
#   role_id     = "WordPressRole"
#   title = "WordPress Role"
#   description       = "Role to be used by Wordpress stack"
#   permissions = ["cloudsql.instances.list"]
# }

# resource "google_service_account_iam_member" "service_account_iam_additive" {
#   service_account_id = google_service_account.wordpress_sa.name
#   role               = "${google_project_iam_custom_role.wordpress_custom_role.name}"
#   member             = "serviceAccount:${google_service_account.wordpress_sa.email}"
# }