resource "digitalocean_droplet" "web" {
  count = 2
  image = "ubuntu-20-04-x64"
  name = "web-${count.index}"
  size = var.droplet_size
  region = var.region
}

resource "digitalocean_loadbalancer" "web" {
  name = "web-lb"
  region = var.region

  forwarding_rule {
    entry_protocol  = "http"
    entry_port      = 80
    target_protocol = "http"
    target_port     = 80
  }
  
  healthcheck {
    protocol               = "http"
    port                   = 80
    path                   = "/"
    check_interval_seconds = 10
    response_timeout_seconds = 5
    healthy_threshold   = 5
    unhealthy_threshold = 3
  }
  
  droplet_ids = digitalocean_droplet.web.*.id
}

resource "digitalocean_database_cluster" "postgres" {
  name = "postgres-db"
  engine = "pg"
  version = "12"
  size = "db-s-1vcpu-1gb"
  region = var.region
  node_count = 1
}
