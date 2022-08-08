locals {
  target_http_proxy_name = join("-", [var.load_balancer_name, "http-proxy"])
  url_map_name = join("-", [var.load_balancer_name, "url-map"])
  health_check_name = join("-", [var.load_balancer_name, "hc-default"])
  backend_service_name = join("-", [var.load_balancer_name, "backend-default"])
  firewall_name = join("-", [var.load_balancer_name, "fw"])
}

  resource "google_compute_health_check" "default" {
      check_interval_sec  = 5
      healthy_threshold   = 2
      name                = local.health_check_name
      timeout_sec         = 5
      unhealthy_threshold = 2

      tcp_health_check {
          port         = 80
          proxy_header = "NONE"
        }

      log_config {
          enable = false
        }
    }
    
    resource "google_compute_backend_service" "default" {
      health_checks                   = [
          google_compute_health_check.default.self_link,
        ]
      load_balancing_scheme           = "EXTERNAL"
      name                            = local.backend_service_name
      port_name                       = "http"
      protocol                        = "HTTP"
      session_affinity                = "NONE"
      timeout_sec                     = 10

      backend {
          group                        = var.instance_group
        }

      log_config {
          enable      = true
          sample_rate = 1
        }
        depends_on = [
          google_compute_health_check.default
        ]
    }

  resource "google_compute_firewall" "default-hc" {
      direction               = "INGRESS"
      disabled                = false
      name                    = local.firewall_name
      network                 = var.network_name
      priority                = 1000
      source_ranges           = [
          "130.211.0.0/22",
          "35.191.0.0/16",
        ]
      target_tags             = [
          var.http_tag,
          var.https_tag,
        ]

      allow {
          ports    = [
              "80",
            ]
          protocol = "tcp"
        }
    }

  resource "google_compute_global_forwarding_rule" "http" {
      ip_protocol           = "TCP"
      load_balancing_scheme = "EXTERNAL"
      name                  = var.load_balancer_name
      port_range            = "80"
      ip_address = var.public_address
      target                = google_compute_target_http_proxy.default.self_link
      depends_on = [
        google_compute_target_http_proxy.default
      ]
    }

  resource "google_compute_url_map" "default" {
      default_service    = google_compute_backend_service.default.self_link
      name               = local.url_map_name
      depends_on = [
        google_compute_backend_service.default
      ]
    }

  resource "google_compute_target_http_proxy" "default" {
      name               = local.target_http_proxy_name
      url_map            = google_compute_url_map.default.self_link
      depends_on = [
        google_compute_url_map.default
      ]
    }
