# Terraform AWS Infrastructure

This Terraform code sets up an AWS infrastructure with the following resources:

- **AWS VPC**: Configures a Virtual Private Cloud (VPC) for the application.
- **AWS Internet Gateway**: Provides internet access to the resources within the VPC.
- **AWS Subnet**: Creates a subnet within the VPC to launch instances.
- **AWS Route Table**: Defines routing rules for the VPC.
- **AWS Route Table Association**: Associates the subnet with the route table.
- **AWS Security Group**: Configures security group rules to control inbound and outbound traffic.
- **AWS EC2 Instance**: Launches an EC2 instance with a user data script to set up a Dockerized Nginx server.

## Prerequisites

Before you begin, make sure you have the following prerequisites:

**AWS Credentials**: Configure your AWS credentials to authenticate Terraform with your AWS account.

## Usage

1. Clone this repository to your local machine.

```bash
git clone https://github.com/yourusername/your-repo.git
```
2. Navigate to the cloned repository directory.
```
cd your-repo
```
3. Update the terraform.tfvars file with your desired variable values.

4. Initialize Terraform in the directory.
```
terraform init
```
5. Review the plan to see the changes that will be applied.
```
terraform plan
```
6. Apply the changes to create the AWS infrastructure.
```
terraform apply
```
7. Once the infrastructure is created, you can access the Nginx server using the public IP of the EC2 instance on port 8080.
## Clean Up
To clean up and destroy the AWS resources created by Terraform, run:
```
terraform destroy
```
## Variables
This Terraform code uses the following variables (defined in terraform.tfvars or through other means):

`sub_sider_block`: The CIDR block for the subnet.<br>
`vpc_sider_block`: The CIDR block for the VPC.<br>
`avail_zone`: The availability zone for the subnet.<br>
`env_prefix`: A prefix to be used for naming resources.<br>
`my_ip`: Your IP address allowed for SSH access.<br>
`instance_type`: The EC2 instance type for the server.<br>
## Note
Please ensure that you have appropriate IAM permissions to create AWS resources.
