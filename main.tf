resource "random_string" "secret_suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  rendered_user_data = templatefile("${path.module}/user_data.sh.tpl", {
    region = var.aws_region
  })
}

resource "aws_instance" "bedrockflask" {
  depends_on = [aws_security_group.bedrockflask, aws_iam_instance_profile.bedrockflask]
  count                  = 2
  ami                    = var.bedrockflask_ami_id
  instance_type          = "t3.large"
  iam_instance_profile   = aws_iam_instance_profile.bedrockflask.name
  vpc_security_group_ids = [aws_security_group.bedrockflask.id, aws_security_group.alb.id]
  key_name               = var.key_name
  subnet_id              = data.aws_subnets.public.ids[count.index % length(data.aws_subnets.public.ids)]
    
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }
  
  user_data = base64encode(local.rendered_user_data)

  tags = {
    Name = "bedrockflask-quickstart-${count.index}"
  }
}