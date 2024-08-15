// Please update the REGION value in the user-data script based on your region. Default is us-east-1.

resource "aws_instance" "test_instance" {
  depends_on = [ aws_vpc.vpc, aws_subnet.public_subnet, aws_security_group.openaiflask, aws_iam_instance_profile.openaiflask ]
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
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    LOG_FILE='/home/ec2-user/test_ami_il_central_1.log'
    ERROR_FILE='/home/ec2-user/test_ami_error_il_central_1.log'
    COMPLETION_LOG='/home/ec2-user/script_completion.log'

    exec > >(tee -a $LOG_FILE) 2> >(tee -a $ERROR_FILE >&2)

    log_exit() {
      exit_code=$?
      end_time=$(date +"%Y-%m-%d %T")
      {
        echo "Script execution completed at $end_time"
        echo "Exit code: $exit_code"
        if [ $exit_code -ne 0 ]; then
          echo "Error occurred. Check $ERROR_FILE for details."
        fi
      } >> $COMPLETION_LOG
    }

    trap log_exit EXIT

    echo "Starting script execution at $(date +"%Y-%m-%d %T")..."

    echo 'Verifying Redis installation...'
    if redis-cli ping | grep -q 'PONG'; then
        echo 'Redis installation successful and service is running.'
    else
        echo 'Redis installation failed or service is not responding correctly.'
        exit 1
    fi
    
    echo 'Checking if /home/ec2-user/openaiflask directory exists...'
    if [ -d '/home/ec2-user/openaiflask' ]; then
        echo 'Directory /home/ec2-user/openaiflask exists.'
    else
        echo 'Directory /home/ec2-user/openaiflask does not exist.'
        exit 1
    fi
    
    echo 'Checking if /home/ec2-user/py3.11-venv directory exists...'
    if [ -d '/home/ec2-user/py3.11-venv' ]; then
        echo 'Directory /home/ec2-user/py3.11-venv exists.'
    else
        echo 'Directory /home/ec2-user/py3.11-venv does not exist.'
        exit 1
    fi
    
    echo 'Activating the virtual environment...'
    cd /home/ec2-user/openaiflask
    source /home/ec2-user/py3.11-venv/bin/activate
    
    echo 'Installing dependencies and launching the application...'
    pip install -r /home/ec2-user/openaiflask/app/requirements.txt
    
    nohup env REGION=us-east-1 FLASK_APP=run FLASK_ENV=development OPENAI_SECRET_NAME=OpenAI-API-Key-for-AMI-quickstart FLASK_SECRET_NAME=Flask-secret-key-for-ami-quickstart REDIS_URL=redis://localhost:6379/0 gunicorn --bind 0.0.0.0:8000 run:app &
    
    sleep 100
    
    echo 'Testing Flask application endpoint...'
    if curl -s http://127.0.0.1:8000 | grep -q '<title>OpenAI Chat</title>'; then
        echo 'Flask application is running successfully.'
    else
        echo 'Flask application did not respond correctly.'
        exit 1
    fi
    
    echo 'Main script execution completed successfully.'
  EOF
  )

  tags = {
    Name = "openaiflask-quickstart-${count.index}"
  }
}

resource "aws_lb_target_group_attachment" "openaiflask" {
  target_group_arn = aws_lb_target_group.openaiflask.arn
  target_id        = aws_instance.test_instance.id
  port             = 8000
}
