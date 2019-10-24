variable "key_par_name" {
    default = "id_rsa"
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
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

variable "AWSAccessKeyId" {
    default = ""
}

variable "AWSSecretKey" {
    default = ""
}

provider "aws" {
  region     = "eu-central-1"
  access_key = "${var.AWSAccessKeyId}"
  secret_key = "${var.AWSSecretKey}"
}

resource "aws_lightsail_instance" "grimoirelab_demo" {
  name              = "${var.name}-${random_id.id.hex}"
  availability_zone = "eu-central-1a"
  blueprint_id      = "debian_9_5"
  bundle_id         = "large_2_0"
  key_pair_name     = "${var.key_par_name}"
  tags = {
    type = "${var.name}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt update",
      "sudo apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common",
      "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get -y install docker-ce docker-ce-cli containerd.io",
      "sudo groupadd docker",
      "sudo usermod -aG docker $USER"
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose"
    ]

    connection {
      host = "${self.public_ip_address}"
      type = "ssh"
      user = "admin"
      timeout = "5m"
      agent = true
    }
  }
}

output "public_ip" {
  value = "${self.public_ip_address}"
}