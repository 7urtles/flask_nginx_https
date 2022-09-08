#!/bin/bash

proj_name() {
  read -p "Enter a name for your project: " project_name
}

site_name() {
  read -p "Enter public IP address and/or DOMAINS to be used for the application seperated by spaces.\nExample: 165.156.51.125 mysite.com www.mysite.com: " domain_name
}
get_port() {
  read -p "Enter desired application port: " application_port
}
setup_nginx() {
  sudo apt update
  sudo apt install -y python3 python3-pip nginx python3-setuptools git
  sudo apt install nginx
  sudo ufw allow 80
  sudo ufw allow 443
}

setup_venv() {
  sudo apt install python3-venv
  sudo mkdir /var/www/${project_name}
  python3 -m venv /var/www/${project_name}/venv
  source /var/www/${project_name}/venv/bin/activate
  pip install uwsgi flask flask-restful gunicorn
  deactivate
}

create_files() {
  sudo touch /var/www/${project_name}/${project_name}.py
  sudo echo -e "from flask import Flask\napp=Flask(__name__)\n@app.route('/')\ndef home():\n  return 'Online!'\n\napp.run(host='0.0.0.0',port=$application_port)" > /var/www/${project_name}.py
  sudo echo -e "\nserver {\n        root /var/www/html;\n\n        index index.html index.htm index.nginx-debian.html;\n    server_name $domain_name;\n\n        location /static {\n                alias /var/www/${project_name}/static;\n        }\n        location / {\n                try_files \$uri \$uri/ =404;\n                proxy_pass http://127.0.0.1:$application_port;\n                proxy_set_header Host \$host;\n                proxy_set_header X-Real-IP \$remote_addr;\n                proxy_redirect off;\n        }\n}" | sudo tee /etc/nginx/sites-available/default -a
}

config_certbot() {
  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot
  sudo certbot --nginx
}

load_application() {
  sudo systemctl restart nginx
  source /var/www/${project_name}/venv/bin/activate
  python3 /var/www/${project_name}/${project_name}.py
}

proj_name;
get_port;
site_name;
setup_nginx;
setup_venv;
create_files;
config_certbot;
load_application;
