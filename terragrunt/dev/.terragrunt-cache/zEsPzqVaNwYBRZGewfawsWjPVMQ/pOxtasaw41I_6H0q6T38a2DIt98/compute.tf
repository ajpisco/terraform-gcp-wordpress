module "wordpress_instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.8.0"

  service_account = {
    email  = google_service_account.wordpress_sa.email
    scopes = ["cloud-platform"]
  }
  machine_type = "e2-medium"
  disk_size_gb         = 10
  source_image_project = "debian-cloud"
  source_image         = "debian-11-bullseye-v20220719"
  access_config = []
  name_prefix          = "wordpress-${var.env}-template"
  network = module.wordpress-vpc.network_name
  subnetwork = module.wordpress-subnet.subnets["australia-southeast1/wordpress-subnet"].name
  startup_script = file(var.metadata_script)
  tags = ["workspace-https", "workspace-http"]
}

module "wordpress_compute_mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "7.8.0"

  instance_template = module.wordpress_instance_template.self_link
  project_id = var.project
  region = var.region
  hostname         = "wordpress-${var.env}"
  autoscaling_enabled = "true"
  max_replicas = 4
  min_replicas = 2
  autoscaling_cpu = [{
    "target": 0.8
  }]
  named_ports = [{
    "name": "http",
    "port": 80
  }]
}