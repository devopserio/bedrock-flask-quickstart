resource "random_string" "secret_suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  rendered_user_data = templatefile("${path.module}/user_data.sh.tpl", {
    region = var.aws_region
    openai_secret_name = aws_secretsmanager_secret.openai_api_key.name
    flask_secret_name = aws_secretsmanager_secret.flask_secret_key.name
  })
}

resource "aws_instance" "openaiflask" {
  depends_on = [aws_vpc.vpc, aws_subnet.public_subnet_1, aws_subnet.public_subnet_2, aws_security_group.openaiflask, aws_iam_instance_profile.openaiflask]
  count                  = 2
  ami                    = var.openaiflask_ami_id
  instance_type          = "t3.large"
  iam_instance_profile   = aws_iam_instance_profile.openaiflask.name
  vpc_security_group_ids = [aws_security_group.openaiflask.id, aws_security_group.alb.id]
  key_name               = var.key_name
  subnet_id              = count.index == 0 ? aws_subnet.public_subnet_1.id : aws_subnet.public_subnet_2.id
    
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }
  
  user_data = base64encode(local.rendered_user_data)

  tags = {
    Name = "openaiflask-quickstart-${count.index}"
  }
}