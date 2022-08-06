# Create SA without roles as we won't need them for this PoC
resource "google_service_account" "wordpress_sa" {
  account_id   = "wordpress-sa"
  display_name = "Service Account to be used by WordPress server"
}

# This module doesn't support SA creation but if we need to add permissions we can use it
module "wordpress_sa" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version = "7.4.1"

 service_accounts = [google_service_account.wordpress_sa.email]
 mode             = "additive"

}