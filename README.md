# OpenAI Flask Application Quickstart

This quickstart guide helps you deploy an OpenAI-powered Flask application on AWS using Terraform. The setup includes an EC2 instance, an Application Load Balancer (ALB) with SSL termination, and necessary networking components.

## Prerequisites

Before you begin, ensure you have the following:

1. An AWS account
2. Terraform installed on your local machine (version 0.12 or later)
3. AWS CLI installed and configured with your credentials
4. A domain registered in Amazon Route 53
5. Basic knowledge of AWS, Terraform, and command-line operations
6. Subscription to the DevOpser Flask AMI (see instructions below)

## Subscribing to the DevOpser Flask AMI

Before you can use this quickstart, you need to subscribe to the DevOpser Flask AMI from the AWS Marketplace. Follow these steps:

1. Visit the [DevOpser Flask AMI page on AWS Marketplace](https://aws.amazon.com/marketplace/pp/prodview-tti62q7ulbcoq).

2. Click on the "Continue to Subscribe" button.

3. Review the terms and conditions, then click "Accept Terms".

4. Once your subscription is active, click on "Continue to Configuration".

5. On the configuration page:
   - Select the AWS region closest to your users to reduce latency (e.g., North Virginia).
   - Click on "Continue to Launch".

6. On the launch options page:
   - Select "Launch through EC2" from the "Choose Action" dropdown.
   - Click on "Launch".

7. You'll be redirected to the EC2 launch wizard. You don't need to launch an instance manually - just note down the AMI ID displayed on this page. You'll need this for the `openaiflask_ami_id` variable in your `terraform.tfvars` file.

8. Your subscription is now active, and you can use the AMI ID in your Terraform configuration.

## Getting Started

1. Clone this repository to your local machine.
2. Navigate to the project directory.

## Configuration

Create a `terraform.tfvars` file in the project directory to set the required variables. Here's a template with explanations:

```hcl
aws_region         = "us-east-1"  # The AWS region to deploy resources
openaiflask_ami_id = "ami-xxxxxxxxxxxxxxxxx"  # AMI ID from the subscription process
key_name           = "your-key-pair-name"  # Your EC2 key pair name
private_key_path   = "/path/to/your/private-key.pem"  # Path to your private key file
your_ip_address    = "x.x.x.x"  # Your IP address for SSH access
domain_name        = "yourdomain.com"  # Your registered domain in Route 53
```

### Variable Values

- `aws_region`: Choose the AWS region where you want to deploy the resources. This should match the region you selected during the AMI subscription process.
- `openaiflask_ami_id`: Use the AMI ID you noted down during the subscription process.
- `key_name`: Create an EC2 key pair in your AWS account and provide its name.
- `private_key_path`: The local path to the private key file of your EC2 key pair.
- `your_ip_address`: Your current public IP address. You can find this by searching "what is my ip" on Google.
- `domain_name`: The domain you've registered in Amazon Route 53.

## Deployment Steps

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Review the planned changes:
   ```
   terraform plan
   ```

3. Apply the configuration:
   ```
   terraform apply
   ```

4. Confirm the changes by typing `yes` when prompted.

5. Wait for the deployment to complete. This may take several minutes.

6. Once complete, Terraform will output the URL of your application.

## Accessing Your Application

After successful deployment, you can access your application at:

```
https://openaiflask.yourdomain.com
```

Replace `yourdomain.com` with your actual domain name.

## Cleaning Up

To avoid incurring unnecessary costs, remember to destroy the resources when you're done:

```
terraform destroy
```

Confirm the destruction by typing `yes` when prompted.

## Important Notes

1. **Costs**: This quickstart creates AWS resources that may incur costs. Be sure to review the AWS pricing for EC2 instances, Application Load Balancers, and associated services.

2. **Security**: While this quickstart provides a basic secure setup, it's recommended to implement additional security measures for production use.

3. **EC2 in Public Subnet**: This quickstart deploys the EC2 instance in a public subnet for simplicity. For enhanced security in a production environment, consider deploying the EC2 instance in a private subnet accessed via an OpenVPN Access Server. DevOpser can assist with implementing this more secure architecture if needed.

4. **SSL Certificate**: The quickstart uses AWS Certificate Manager for SSL. Ensure your domain is properly set up in Route 53 for successful certificate validation.

5. **Dependencies**: Make sure all dependencies (Terraform, AWS CLI) are correctly installed and configured before starting.

## Support

For any questions or assistance with this quickstart, please contact DevOpser at info@devopser.io. We're here to help you implement more advanced configurations or address any issues you may encounter.

## Disclaimer

This quickstart is provided as-is. Always review and understand the code before deploying resources in your AWS account. DevOpser is not responsible for any costs incurred or security issues that may arise from using this quickstart.