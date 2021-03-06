# Setting up Google Cloud Platform account

We will be working with [Google Cloud Compute (GCP) Container-Optimized OS (COS) instances](https://cloud.google.com/container-optimized-os/).

Things you need to do:
* [Create a Google Cloud Platform project](https://cloud.google.com/resource-manager/docs/creating-managing-projects), and take note of its ID.
* [Download your credentials .json file](https://cloud.google.com/docs/authentication/end-user#creating_your_client_credentials) into `grimoirelab-infra-provision/gcp`
* [Add your SSH key to your account](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys)

# Setting your local environment and getting remote machinery ready

1. Change your working directory to `grimoirelab-infra-provision/gcp`:
```
cd grimoirelab-infra-provision/gcp
```

2. Inside `grimoirelab-infra-provision/gcp` create a file called `terraform.tfvars` with the following format and content:
```
gcp_credentials_file = "<GCP_CREDENTIALS_FILE>.json"
gcp_project_name = "<GCP_PROJECT_ID>"
```

3. Initialize Terraform:
```
terraform init
```

4. Let's create your first GCP COS Virtual Machine. It will read both your `terraform.tfvars` and `provision.tf` files.
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
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

public_ip = 157.245.85.159
```

You are ready for [next steps](../README.md#step-2-deploy-and-manage-grimoirelab-in-your-cloud-infrastructure)