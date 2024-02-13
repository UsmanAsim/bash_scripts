# Step-1
Install Terraform

sudo yum install -y yum-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

sudo yum -y install terraform


# Step-2
Install AWS-Cli

sudo curl “https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o “awscliv2.zip”

sudo unzip awscliv2.zip

sudo ./aws/install

# Step-3 
Create SSH keys by running the command

> ssh-keygen


# Step-4 
setup aws accesskey and secret

> aws configure

it will prompt to enter the below

AWS Access Key ID [****************T4PL]:
AWS Secret Access Key [****************HkIn]:
Default region name [us-east-1]:
Default output format [None]:



# Step-5 
terraform.tfvars
Once you configured the aws provided. Now, its time to edit the terraform.tfvars file
Replace the IP with your current Public-IP
Mentioned the secret-key location

# Step-6
entry-script.sh
If you which to install and software then mentioned in the script file. 
It is not recommended to install software using the terraform. To configure the software used Ansible. This is just for a demo purpose

# Step-7
main.tf

This file contains all the information related to instance creation. Image used, VPC, Subnet, Security Gateway, Firewall and etc

# Step-8
commands
>terraform init
>terraform plan
>terraform apply
>terraform apply -auto-approve

