# Setting up Google Cloud Platform account

Things you need to do:
* [Create a Google Cloud Platform project](https://cloud.google.com/resource-manager/docs/creating-managing-projects), and take note of its ID.
* [Download your credentials .json file into `grimoirelab-infra-provision/gcp`](https://cloud.google.com/docs/authentication/end-user#creating_your_client_credentials)

# Setting your local environment and getting remote machinery ready

1. Change your working directory to `grimoirelab-infra-provision/gcp`:
```
cd grimoirelab-infra-provision/gcp
```

2. Inside `grimoirelab-infra-provision/do` create a file called `terraform.tfvars` with the following format and content:
```
gcp_credentials_file = "<GCP_CREDENTIALS_FILE>.json"
gcp_project_name = "<GCP_PROJECT_ID>"
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