# GrimoireLab Infrastructure Provision

Set of tools and scripts to set up and deploy GrimoireLab infrastructure in cloud
providers.

## Requirements

* [Ansible](https://www.ansible.com/)
* [Terraform](https://www.terraform.io/)
* An account set up in one cloud provider, including SSH access, access tokens, 
or whatever mechanisms they provide. By now, this project has support for:
  * Digital Ocean

# Setting up your cloud provider account

## Digital Ocean

We will be working with this thing Digital Ocean call [Droplets](https://www.digitalocean.com/products/droplets/).
Things you need to do:
* [Add your SSH key to your account](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/)
* [Create a Digital Ocean Personal Token](https://www.digitalocean.com/docs/api/create-personal-access-token/)
* Get your [SSH fingerprint](https://en.wikipedia.org/wiki/Public_key_fingerprint): `ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub`

# Setting your local environment and 1st deployment

Let's go for the steps needed to start playing with this project:

1. Clone it into your laptop / machine. I've only tested it in Linux, so I cannot promise it'll work the same in MacOS or MS Windows. It will create a folder called `grimoirelab-infra-provision`.

2. Inside `grimoirelab-infra-provision` create a file called `terraform.tfvars` with the following format and content:
```
do_token = "<DIGITAL_OCEAN_PERSONAL_TOKEN>"
ssh_fingerprint = "<YOUR_SSH_FINGERPRINT>"
```

3. Initialize Terraform:
```
terraform init
```

4. Let's create your first droplet. It will read both your `terraform.tfvars` and `provision.tf` files:
```
terraform apply -var name=<GIVE_IT_A_NAME>
```

# License

GPLv3