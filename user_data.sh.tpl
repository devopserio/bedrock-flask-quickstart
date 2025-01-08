#!/bin/bash
set -e
LOG_FILE='/home/ec2-user/quickstart.log'
ERROR_FILE='/home/ec2-user/quickstart_error.log'
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

echo 'Main script execution completed successfully.'