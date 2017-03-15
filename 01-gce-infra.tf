##Google Infrastructure
provider "google" {
  credentials = "${file("${var.gce_creds_path}")}"
  project     = "${var.gce_project}"
  region      = "${var.gce_region}"
}

##Create Swarm Firewall Rules
resource "google_compute_firewall" "swarm_sg" {
  name    = "swarm-sg"
  network = "default"

  allow {
    protocol = "udp"
    ports    = ["7946"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "2377", "7946", "4789"]
  }
}

##Create GCE Swarm Members
resource "google_compute_instance" "gce-swarm-members" {
  depends_on   = ["google_compute_firewall.swarm_sg"]
  name         = "swarm-member-${count.index}"
  machine_type = "${var.gce_instance_size}"
  zone         = "${var.gce_region}-a"
  count        = "${var.gce_worker_count}"

  disk {
    image = "ubuntu-os-cloud/ubuntu-1604-lts"
  }

  disk {
    type    = "local-ssd"
    scratch = true
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "ubuntu:${file("${var.public_key_path}")}"
  }
}
