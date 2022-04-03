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
  sudo apt install nginx
  sudo ufw allow 80
  sudo ufw allow 443
}

setup_venv() {
  mkdir $project_name && cd $project_name
  python3 -m venv venv
  source venv/bin/activate
  pip install flask
  deactivate
}

create_files() {
  touch ${project_name}.py
  echo -e "from flask import Flask\napp=Flask(__name__)\n@app.route('/')\ndef home():\n  return 'Online!'\n\napp.run(host='0.0.0.0',port=$application_port)" > ${project_name}.py
  sudo echo -e "\nserver {\n        root /var/www/html;\n\n        index index.html index.htm index.nginx-debian.html;\n    server_name $domain_name;\n\n        location /static {\n                alias $HOME/$project_name/static;\n        }\n        location / {\n                try_files \$uri \$uri/ =404;\n                proxy_pass http://127.0.0.1:$application_port;\n                proxy_set_header Host \$host;\n                proxy_set_header X-Real-IP \$remote_addr;\n                proxy_redirect off;\n        }\n}" | sudo tee /etc/nginx/sites-available/default -a
}

config_certbot() {
  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot
  sudo certbot --nginx
}

load_application() {
  sudo systemctl restart nginx
  source venv/bin/activate
  python3 $project_name.py
}

proj_name;
get_port;
site_name;
setup_nginx;
setup_venv;
create_files;
config_certbot;
load_application;
