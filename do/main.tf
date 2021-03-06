variable "do_token" {
  description = "Digital Ocean personal token"
  default = ""
}

variable "ssh_fingerprint" {
  default = ""
}

variable "name" {
  default = "grimoirelab-demo"
}

resource "random_id" "id" {
 byte_length = 4
}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "demos" {
  name = "${var.name}-${random_id.id.hex}"
  image = "docker-18-04"
  size = "8gb"
  region = "nyc1"
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt update",
      "sudo apt-get -y install python-minimal"
    ]

    connection {
      host = "${digitalocean_droplet.demos.ipv4_address}"
      type = "ssh"
      user = "root"
      timeout = "5m"
      agent = true
    }
  }

  # provisioner "local-exec" {
  #   command = "ansible-playbook -i ${digitalocean_droplet.demos.ipv4_address}, --private-key ${var.pvt_key} deploy.yml"
  # }
}

output "public_ip" {
  value = "${digitalocean_droplet.demos.ipv4_address}"
}