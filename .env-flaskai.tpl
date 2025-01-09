FLASK_APP=run
FLASK_ENV=development

FLASK_SECRET_NAME=${flask_secret_name}
REDIS_URL=redis://localhost:6379/0
REGION=us-east-1

DB_NAME_SECRET_NAME=${db_name_secret_name}
DB_USER_SECRET_NAME=${db_user_secret_name}
DB_PASSWORD_SECRET_NAME=${db_password_secret_name}
DB_HOST_SECRET_NAME=${db_host_secret_name}
DB_PORT_SECRET_NAME=${db_port_secret_name}

MAIL_SERVER=${mail_server}
MAIL_PORT=${mail_port}
MAIL_USE_TLS=${mail_use_tls}
MAIL_USERNAME=${email}
MAIL_DEFAULT_SENDER=${email}
MAIL_PASSWORD_SECRET_NAME=${mail_password_secret_name}

ADDITIONAL_SECRETS=${additional_secrets}
ADMIN_USERS_SECRET_NAME=${admin_users_secret_name}