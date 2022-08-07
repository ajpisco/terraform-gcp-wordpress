module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.8.0"

  service_account = {
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }
  region               = var.region
  machine_type         = var.machine_type
  disk_size_gb         = 10
  source_image_project = var.source_image_project
  source_image         = var.source_image
  access_config        = []
  name_prefix          = var.template_name_prefix
  network              = var.network_name
  subnetwork           = var.subnet_name
  startup_script       = file("scripts/boot.sh")
  tags                 = [var.https_tag, var.http_tag]
}

module "compute_mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "7.8.0"

  instance_template   = module.instance_template.self_link
  project_id          = var.project_id
  region              = var.region
  hostname            = var.hostname
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
  depends_on = [module.instance_template.self_link]
}