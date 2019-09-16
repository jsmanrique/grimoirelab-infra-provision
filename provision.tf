variable "do_token" {
  description = "Digital Ocean personal token"
  default = ""
}
variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
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
      "sudo apt-get -y install python-minimal",
      "sudo sysctl -w vm.max_map_count=262144",
      # "git clone https://gitlab.com/Bitergia/lab/analytics-demo.git",
      "git clone --recurse-submodules https://gitlab.com/jsmanrique/grimoirelab-with-opendistro.git",
      "cd grimoirelab-with-opendistro",
      "docker-compose up -d"
    ]

    connection {
      host = "${digitalocean_droplet.demos.ipv4_address}"
      type = "ssh"
      user = "root"
      timeout = "2m"
    }
  }

  # provisioner "local-exec" {
  #   command = "ansible-playbook -i ${digitalocean_droplet.demos.ipv4_address}, --private-key ${var.pvt_key} deploy.yml"
  # }
}
output "public_ip" {
  value = "${digitalocean_droplet.demos.ipv4_address}"
}