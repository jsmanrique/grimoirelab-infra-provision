# Setting up Digital Ocean account

We will be working with this thing Digital Ocean call [Droplets](https://www.digitalocean.com/products/droplets/).
Things you need to do:
* [Add your SSH key to your account](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/)
* [Create a Digital Ocean Personal Token](https://www.digitalocean.com/docs/api/create-personal-access-token/)
* Get your [SSH fingerprint](https://en.wikipedia.org/wiki/Public_key_fingerprint): `ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub`

# Setting your local environment and getting remote machinery ready

1. Change your working directory to `grimoirelab-infra-provision/do`:
```
cd grimoirelab-infra-provision/do
```

2. Inside `grimoirelab-infra-provision/do` create a file called `terraform.tfvars` with the following format and content:
```
do_token = "<DIGITAL_OCEAN_PERSONAL_TOKEN>"
ssh_fingerprint = "<YOUR_SSH_FINGERPRINT>"
```

3. Initialize Terraform:
```
terraform init
```

4. Let's create your first droplet. It will read both your `terraform.tfvars` and `provision.tf` files.
```
terraform apply -var name=<GIVE_IT_A_NAME>
```

During the process, Terraform might ask for confirmation to apply the changes you
have requested. If you want to say `yes` to everything, just run:
```
terraform apply -auto-approve -var name=<GIVE_IT_A_NAME>
```

At the end of the process, Terraform outputs the public IP to access to the
machine you have created. Something like:
```
digitalocean_droplet.demos: Creation complete after 2m2s [id=160048525]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public_ip = 157.245.85.159
```

You are ready for [next steps](../README.md#step-2-deploy-and-manage-grimoirelab-in-your-cloud-infrastructure)