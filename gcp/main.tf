variable "gcp_credentials_file" {
    description = "Google Cloud Platform .json credentials file"
    default = ""
}

variable "gcp_project_name" {
    description = "Google Cloud Platform project name"
    default = ""
}

variable "name" {
  default = "grimoirelab-demo"
}

// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("${var.gcp_credentials_file}")}"
 project     = "${var.gcp_project_name}"
 region      = "us-west1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 4
}

resource "google_compute_firewall" "http-traffic" {
  name    = "allow-http-${random_id.instance_id.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-traffic"]
}

resource "google_compute_firewall" "http-ssh" {
  name    = "allow-ssh-${random_id.instance_id.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-traffic"]
}

resource "google_compute_firewall" "elasticsearch" {
  name    = "elasticsearch-${random_id.instance_id.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9200","9300"]
  }

  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_firewall" "kibana" {
  name    = "kibana-${random_id.instance_id.hex}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5601"]
  }

  source_ranges = ["0.0.0.0/0"]

}

// A single Google Cloud Engine instance
resource "google_compute_instance" "demo" {
 name         = "${var.name}-${random_id.instance_id.hex}"
 machine_type = "n1-standard-2"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "cos-cloud/cos-stable-77-12371-89-0"
   }
 }

 network_interface {
     network = "default"
     access_config {
         // this empty block creates a public IP address
     }
 }

#  metadata_startup_script = <<SCRIPT
#  echo alias docker-compose="'"'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w="$PWD" docker/compose:1.24.1'"'" >> ~/.bashrc
#  source ~/.bashrc
#  SCRIPT
  metadata_startup_script = "sudo sysctl -w vm.max_map_count=262144"

}

output "public_ip" {
    value = "${google_compute_instance.demo.network_interface[0].access_config[0].nat_ip}"
}