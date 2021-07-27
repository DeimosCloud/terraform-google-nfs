locals {
  nfs_tag          = ["nfs"]
  tags             = toset(concat(var.tags, local.nfs_tag))
  private_key_file = "private-key.pem"
  zone             = var.zone == null ? data.google_compute_zones.available.names[0] : var.zone

  access_config = [{
    nat_ip       = google_compute_address.default.address
    network_tier = var.network_tier
  }]
}

data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
}

resource "google_compute_firewall" "nfs_firewall_rule" {
  name    = "${var.name_prefix}-nfs"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["111", "2049"]
  }

  allow {
    protocol = "udp"
    ports    = ["111", "2049"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = local.nfs_tag
}

resource "google_compute_address" "default" {
  name         = "${var.name_prefix}-nfs-ip"
  region       = var.region
  network_tier = var.attach_public_ip == false ? null : var.network_tier
  address_type = var.attach_public_ip == false ? "INTERNAL" : "EXTERNAL"
}

// Use an external disk so that it can be remounted on another instance.
resource "google_compute_disk" "default" {
  name  = "${var.name_prefix}-disk"
  image = var.image_family
  size  = var.capacity_gb
  type  = var.disk_type
  zone  = local.zone
}

####################
# Instance Template
####################
resource "google_compute_instance_template" "tpl" {
  name_prefix             = "${var.name_prefix}-"
  project                 = var.project
  machine_type            = var.machine_type
  labels                  = var.labels
  metadata                = var.metadata
  tags                    = local.tags
  metadata_startup_script = <<SCRIPT
    #  Clean Up exports file
    > /etc/exports

    #  Install and Configure NFS server
    apt update && apt install -y nfs-kernel-server
    %{for path in var.export_paths}
    mkdir -p ${path}
    chown nobody:nogroup ${path}
    chmod 777 ${path}
    echo '${path} *(rw,sync,no_subtree_check)' >> /etc/exports
    %{endfor}
    systemctl restart nfs-kernel-server

    # Setup Stackdriver
    curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
    sudo bash add-monitoring-agent-repo.sh --also-install
    sudo service stackdriver-agent start
  SCRIPT

  region = var.region

  disk {
    auto_delete = var.auto_delete_disk
    boot        = true
    source      = google_compute_disk.default.name
  }

  dynamic "service_account" {
    for_each = [var.service_account]
    content {
      email  = lookup(service_account.value, "email", null)
      scopes = lookup(service_account.value, "scopes", null)
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    dynamic "access_config" {
      for_each = var.attach_public_ip == false ? [] : local.access_config
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }

  lifecycle {
    create_before_destroy = "true"
  }
}

resource "google_compute_instance_from_template" "compute_instance" {
  provider = google
  name     = "${var.name_prefix}-${format("%03d", 1)}"
  project  = var.project
  zone     = local.zone

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    dynamic "access_config" {
      for_each = var.attach_public_ip == false ? [] : local.access_config
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }

  source_instance_template = google_compute_instance_template.tpl.self_link
}
