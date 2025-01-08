# bedrock Flask Application Quickstart

This quickstart guide helps you deploy an bedrock-integrated Flask application on AWS using Terraform. The setup includes two EC2 instances, an Application Load Balancer (ALB) with SSL termination, and necessary networking components.

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
4. Review and create the policy, giving it a name like "bedrockFlaskQuickstartPolicy".
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
   - copy the AMI-id and use this in the configuration for the `bedrockflask_ami_id` variable in your `terraform.tfvars` file or upload as a variable in Terraform Cloud.

6. Your subscription is now active, and you can use the AMI ID in your Terraform configuration.

## Getting Started

1. Clone this repository to your local machine.
2. Navigate to the project directory.

## Configuration

Create a `terraform.tfvars` file in the project directory to set the required variables. Here's a template with explanations:

```hcl
# Required Core Variables
aws_region         = "us-east-1"  # The AWS region to deploy resources
bedrockflask_ami_id = "ami-xxxxxxxxxxxxxxxxx"  # AMI ID from the subscription process
key_name           = "your-key-pair-name"  # Your EC2 key pair name
your_ip_address    = "x.x.x.x"  # Your IP address for SSH access
domain_name        = "yourdomain.com"  # Your registered domain in Route 53
subdomain          = "bedrockflask"  # The subdomain for your application
site_name          = "your-site-name"  # Name of your site/application
org_code           = "your-org-code"   # Your organization code

# Database Configuration
prod_db_name      = "your_database_name"  # Name of the production database
POSTGRES_USER     = "your_db_username"    # PostgreSQL database username
POSTGRES_PASSWORD = "your_db_password"    # PostgreSQL database password
POSTGRES_PORT     = "5432"               # PostgreSQL port (default: 5432)

# Mail Server Configuration
mail_password         = "your_mail_password"  # Password for the mail server
email_for_mail_server = "sender@example.com"  # Default sender email address
mail_server          = "smtp.example.com"    # Mail server hostname
mail_port            = "587"                 # Mail server port (default: 587)
mail_use_tls         = "true"               # Whether to use TLS (default: true)

# Application Configuration
flask_secret_key   = "your-flask-secret-key"  # A secret key for Flask
additional_secrets = "{}"  # Additional secrets in JSON format
admin_users        = "[]"  # List of admin users in JSON format

# Network Configuration
public_subnet_cidr_1 = "10.0.1.0/24"  # CIDR for the first public subnet
public_subnet_cidr_2 = "10.0.2.0/24"  # CIDR for the second public subnet
```

### Variable Values

#### Core Configuration
- `aws_region`: Choose the AWS region where you want to deploy the resources
- `bedrockflask_ami_id`: Use the AMI ID from the subscription process
- `key_name`: Create an EC2 key pair in your AWS account and provide its name
- `your_ip_address`: Your current public IP address
- `domain_name`: The domain you've registered in Amazon Route 53
- `subdomain`: The subdomain for your application
- `site_name`: A unique name for your site/application
- `org_code`: Your organization's code for resource naming

#### Database Configuration
- `prod_db_name`: Name of your PostgreSQL database
- `POSTGRES_USER`: Username for database access
- `POSTGRES_PASSWORD`: Strong password for database access
- `POSTGRES_PORT`: Database port (default: 5432)

#### Mail Server Configuration
- `mail_password`: Password for your mail server
- `email_for_mail_server`: Default sender email address
- `mail_server`: SMTP server hostname
- `mail_port`: SMTP server port (default: 587)
- `mail_use_tls`: Enable/disable TLS for mail (default: true)

#### Application Configuration
- `flask_secret_key`: A secret key for Flask session management
- `additional_secrets`: JSON object for any additional secrets
- `admin_users`: JSON array of admin user configurations

#### Network Configuration
- `public_subnet_cidr_1` and `public_subnet_cidr_2`: CIDR blocks for the public subnets

### Secrets Management

This quickstart uses AWS Secrets Manager to securely store sensitive information. The following secrets are managed:

1. Application Secrets:
   - Flask secret key
   - Additional application secrets
   - Admin user configurations

2. Database Secrets:
   - Database name
   - PostgreSQL username
   - PostgreSQL password
   - PostgreSQL port

3. Mail Server Secrets:
   - Mail server password
   - Default sender email
   - Mail server hostname
   - Mail server port
   - TLS configuration

All secrets are stored in AWS Secrets Manager with unique names that include your site name and a random suffix for additional security. You can optionally enable KMS encryption for these secrets by uncommenting the KMS configuration in the code.

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