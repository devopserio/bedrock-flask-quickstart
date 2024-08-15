# OpenAI Flask Application Quickstart

This quickstart guide helps you deploy an OpenAI-integrated Flask application on AWS using Terraform. The setup includes two EC2 instances, an Application Load Balancer (ALB) with SSL termination, and necessary networking components.

## Prerequisites

Before you begin, ensure you have the following:

1. An AWS account
2. Terraform installed on your local machine (version 0.12 or later)
3. AWS CLI installed and configured with your credentials
4. A domain registered in Amazon Route 53
5. Basic knowledge of AWS, Terraform, and command-line operations
6. Subscription to the DevOpser Flask AMI (see instructions below)

## Configuring AWS Credentials

Before running Terraform, you need to configure your AWS credentials. There are several ways to do this, but for this quickstart, we'll use the AWS CLI method:

1. Install the AWS CLI if you haven't already. You can download it from the [official AWS CLI page](https://aws.amazon.com/cli/).

2. Open a terminal and run:
   ```
   aws configure
   ```

3. You'll be prompted to enter your AWS Access Key ID, Secret Access Key, default region name, and default output format. Enter these details as provided by your AWS account administrator.

4. Your credentials will be stored in `~/.aws/credentials` (Linux/macOS) or `%UserProfile%\.aws\credentials` (Windows).

## IAM Permissions

Ensure that the IAM user or role you're using has sufficient permissions to create and manage the required AWS resources. Here's a demo policy that grants the necessary permissions for this quickstart:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "elasticloadbalancing:*",
                "route53:*",
                "acm:*",
                "iam:*",
                "secretsmanager:*",
                "logs:*",
                "autoscaling:*",
                "cloudwatch:*",
                "vpc:*"
            ],
            "Resource": "*"
        }
    ]
}
```

To use this policy:

1. Go to the AWS IAM console.
2. Create a new policy by navigating to "Policies" and clicking "Create policy".
3. In the JSON tab, paste the above policy.
4. Review and create the policy, giving it a name like "OpenAIFlaskQuickstartPolicy".
5. Attach this policy to the IAM user or role you're using for this quickstart.

**Note**: This is a broad policy for demonstration purposes. In a production environment, you should follow the principle of least privilege and grant only the specific permissions needed for your use case.

## Verifying Your AWS Configuration

To verify that your AWS credentials are correctly configured and have the necessary permissions:

1. Run the following AWS CLI command:
   ```
   aws sts get-caller-identity
   ```

2. This should return your AWS account ID, IAM user/role ID, and ARN. If you see this information, your credentials are correctly set up.

3. To check your permissions, you can use the IAM Policy Simulator in the AWS Console, or try a simple AWS CLI command that uses one of the required services, such as:
   ```
   aws ec2 describe-regions
   ```

If these commands work without errors, your AWS configuration should be ready for running this quickstart.

## Subscribing to the DevOpser Flask AMI

Before you can use this quickstart, you need to subscribe to the DevOpser Flask AMI from the AWS Marketplace. Follow these steps:

1. Visit the [DevOpser Flask AMI page on AWS Marketplace](https://aws.amazon.com/marketplace/pp/prodview-tti62q7ulbcoq)

2. Click on the "Continue to Subscribe" button.

3. Review the terms and conditions, then click "Accept Terms".

4. Once your subscription is active, click on "Continue to Configuration".

5. On the configuration page:
   - Select the AWS region closest to your users to reduce latency (e.g., North Virginia).
   - copy the AMI-id and use this in the configuration for the `openaiflask_ami_id` variable in your `terraform.tfvars` file or upload as a variable in Terraform Cloud.

6. Your subscription is now active, and you can use the AMI ID in your Terraform configuration.

## Getting Started

1. Clone this repository to your local machine.
2. Navigate to the project directory.

## Configuration

Create a `terraform.tfvars` file in the project directory to set the required variables. Here's a template with explanations:

```hcl
aws_region         = "us-east-1"  # The AWS region to deploy resources
openaiflask_ami_id = "ami-xxxxxxxxxxxxxxxxx"  # AMI ID from the subscription process
key_name           = "your-key-pair-name"  # Your EC2 key pair name
your_ip_address    = "x.x.x.x"  # Your IP address for SSH access
domain_name        = "yourdomain.com"  # Your registered domain in Route 53
subdomain          = "openaiflask"  # The subdomain for your application
public_subnet_cidr_1 = "10.0.1.0/24"  # CIDR for the first public subnet
public_subnet_cidr_2 = "10.0.2.0/24"  # CIDR for the second public subnet
openai_api_key     = "your-openai-api-key"  # Your OpenAI API key
flask_secret_key   = "your-flask-secret-key"  # A secret key for Flask
```

### Variable Values

- `aws_region`: Choose the AWS region where you want to deploy the resources. This should match the region you selected during the AMI subscription process.
- `openaiflask_ami_id`: Use the AMI ID you noted down during the subscription process.
- `key_name`: Create an EC2 key pair in your AWS account and provide its name.
- `your_ip_address`: Your current public IP address. You can find this by searching "what is my ip" on Google.
- `domain_name`: The domain you've registered in Amazon Route 53.
- `subdomain`: The subdomain you want to use for your application.
- `public_subnet_cidr_1` and `public_subnet_cidr_2`: CIDR blocks for the two public subnets.
- `openai_api_key`: Your OpenAI API key.
- `flask_secret_key`: A secret key for Flask. Generate a strong, random string for this.

**Note on Variable Handling and Terraform Cloud**: While using a `terraform.tfvars` file is convenient for local development, it's not the most secure method for handling sensitive variables in a production environment. For enhanced security and better secret management, we strongly recommend using Terraform Cloud. Here's how to set it up:

1. Fork this repository to your own GitHub account.

2. Sign up for a Terraform Cloud account at [https://app.terraform.io/signup/account](https://app.terraform.io/signup/account) if you haven't already.

3. In Terraform Cloud, create a new workspace and choose "Version control workflow" to connect it to your forked GitHub repository.

4. In your workspace settings, navigate to the "Variables" section. Here, you can add all the variables from the `terraform.tfvars` file as Terraform variables. For sensitive variables like `openai_api_key` and `flask_secret_key`, make sure to mark them as sensitive.

5. To authenticate with AWS, you can use [dynamic provider credentials](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration). 

6. With this setup, you can now run your Terraform operations directly from Terraform Cloud. It will use the variables you've set and the AWS credentials you've provided.

Using Terraform Cloud provides several benefits:
- Secure storage of sensitive variables and state files
- Collaboration features for team environments
- Consistent execution environment
- Integration with version control systems
- Automated runs based on repository changes

You can learn more about Terraform Cloud [here](https://www.terraform.io/cloud).

## Deployment Steps from local

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
https://<subdomain>.<domain_name>
```

Subdomain and domain_name are variables - please note the domain should be hosted on AWS Route53.

## Terraform Outputs

After a successful deployment, Terraform will display several outputs that provide important information about your infrastructure. You can also retrieve these outputs at any time by running `terraform output`. Here are the key outputs:

- `application_url`: The HTTPS URL where you can access your application.
- `alb_dns_name`: The DNS name of the Application Load Balancer.
- `ec2_instance_ids`: The IDs of the EC2 instances running your application.
- `ec2_private_ips`: The private IP addresses of the EC2 instances.
- `vpc_id`: The ID of the VPC where resources are deployed.
- `public_subnet_ids`: The IDs of the public subnets used by the ALB.
- `alb_security_group_id`: The ID of the ALB's security group.
- `ec2_security_group_id`: The ID of the EC2 instances' security group.
- `acm_certificate_arn`: The ARN of the ACM certificate used for HTTPS.
- `route53_zone_id`: The Zone ID of your Route 53 hosted zone.

These outputs can be useful for troubleshooting, further configuration, or integration with other systems.

## Cleaning Up

To avoid incurring unnecessary costs, remember to destroy the resources when you're done:

```
terraform destroy
```

Confirm the destruction by typing `yes` when prompted.

## Important Notes

1. **Costs**: This quickstart creates AWS resources that may incur costs. Based on current estimates, the resources in this configuration cost approximately $142/month to operate. Always review the AWS pricing for EC2 instances, Application Load Balancers, and associated services before deploying.

2. **Security**: While this quickstart provides a basic secure setup, it's recommended to implement additional security measures for production use.

3. **EC2 in Public Subnet**: This quickstart deploys the EC2 instances in public subnets for simplicity. For enhanced security in a production environment, consider deploying the EC2 instances in private subnets accessed via a bastion host, OpenVPN Access Server, or similar solution. This more secure architecture is outside the scope of this quickstart, but DevOpser can assist with implementing such a setup if needed. Please reach out to us for more information.

4. **SSL Certificate**: The quickstart uses AWS Certificate Manager for SSL. Ensure your domain is properly set up in Route 53 for successful certificate validation.

5. **Dependencies**: Make sure all dependencies (Terraform, AWS CLI) are correctly installed and configured before starting.

6. **Sticky Sessions**: This configuration implements sticky sessions on the Application Load Balancer. This ensures that a client is consistently routed to the same target in a group for the duration of a session, which enables a smooth AI chat experience for your users.

7. **Future Cost Optimization**: DevOpser is currently developing the DevOpser Platform for AI Webhosting, which aims to productionalize your application at a fraction of the cost with a single click. This platform is on track for release in Q4 2024. Stay tuned for updates!

## Support

For any questions or assistance with this quickstart, please contact DevOpser at info@devopser.io. We're here to help you implement more advanced configurations, address any issues you may encounter, or discuss how we can help optimize your deployment for enhanced security and cost-effectiveness. It is also open source so feel free to submit a pull request with any changes and we will review them.

## Disclaimer

This quickstart is provided as-is. Always review and understand the code before deploying resources in your AWS account. DevOpser is not responsible for any costs incurred or security issues that may arise from using this quickstart.