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

nohup env REGION=${region} FLASK_APP=run FLASK_ENV=development OPENAI_SECRET_NAME=${openai_secret_name} FLASK_SECRET_NAME=${flask_secret_name} REDIS_URL=redis://localhost:6379/0 gunicorn --bind 0.0.0.0:8000 --workers 4 --threads 5 run:app &

sleep 100

echo 'Testing Flask application endpoint...'
if curl -s http://127.0.0.1:8000 | grep -q '<title>OpenAI Chat</title>'; then
    echo 'Flask application is running successfully.'
else
    echo 'Flask application did not respond correctly.'
    exit 1
fi

echo 'Main script execution completed successfully.'