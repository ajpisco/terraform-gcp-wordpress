module "wordpress_instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.8.0"

  service_account = {
    email  = google_service_account.wordpress_sa.email
    scopes = ["cloud-platform"]
  }
  machine_type         = var.machine_type
  disk_size_gb         = 10
  source_image_project = var.source_image_project
  source_image         = var.source_image
  access_config        = []
  name_prefix          = join("-", [var.template_name_prefix, var.env])
  network              = module.wordpress-vpc.network_name
  subnetwork           = module.wordpress-subnet.subnets["${join("/", [var.region, var.subnetwork_name])}"].name
  startup_script       = file(var.metadata_script)
  tags                 = [var.https_tag, var.http_tag]
}

module "wordpress_compute_mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "7.8.0"

  instance_template   = module.wordpress_instance_template.self_link
  project_id          = var.project_id[var.env]
  region              = var.region
  hostname            = join("-", [var.product_name, var.env])
  autoscaling_enabled = "true"
  max_replicas        = 4
  min_replicas        = 2
  autoscaling_cpu = [{
    "target" : 0.8
  }]
  named_ports = [{
    "name" : "http",
    "port" : 80
  }]
}