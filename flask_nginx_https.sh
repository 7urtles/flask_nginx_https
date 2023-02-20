#!/bin/bash

proj_name() {
  read -p "Enter a name for your project: " project_name
}

site_name() {
  read -p "Enter the domain to be used for the application.\nExample: mysite.com: " domain_name
}
get_port() {
  read -p "Enter desired application port: " application_port
}
install_dependancies() {
  sudo apt update
  sudo apt install python3 python3-pip python3-dev python3-venv build-essential libssl-dev libffi-dev python3-setuptools nginx git -y 
}

setup_venv() {
  sudo mkdir /var/www/${project_name}
  sudo python3 -m venv /var/www/${project_name}/venv
  source /var/www/${project_name}/venv/bin/activate
  pip install wheel flask gunicorn
  deactivate
}

create_wsgi_file() {
  sudo touch /var/www/${project_name}/wsgi.py
  sudo echo -e "from myproject import app\nif __name__ == '__main__':\n    app.run()" > /var/www/${project_name}/wsgi.py
  gunicorn --bind ${domain_name}:${application_port} wsgi:app
}

create_service_file() {
  sudo touch /etc/systemd/system/${project_name}.service
  sudo echo -e "[Unit]\nDescription=Gunicorn instance to serve myproject\nAfter=network.target\n\n[Service]\nUser=$USER\nGroup=www-data\nWorkingDirectory=/var/www/${project_name}/\nEnvironment='PATH=/var/www/${project_name}/venv/bin'\nExecStart=/var/www/${project_name}/venv/bin/gunicorn --workers 3 --bind unix:${project_name}.sock -m 007 wsgi:app\n\n[Install]\nWantedBy=multi-user.target" >/etc/systemd/system/${project_name}.service
}

start_service() {
  sudo systemctl start ${project_name}
  sudo systemctl enable ${project_name}
}

create_nginx_files() {
  sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default_backup
  sudo touch /var/www/${project_name}/${project_name}.py
  sudo echo -e "from flask import Flask\napp=Flask(__name__)\n@app.route('/')\ndef home():\n  return 'Online!'\n\napp.run(host='0.0.0.0',port=$application_port)" > /var/www/${project_name}/${project_name}.py
  sudo touch /etc/nginx/sites-available/${project_name}
  sudo echo -e "\nserver {\n        root /var/www/html;\n\n        index index.html index.htm index.nginx-debian.html;\n        server_name $domain_name;\n\n        location /static {\n                alias /var/www/${project_name}/static;\n        }\n        location / {\n     alias /var/www/${project_name}/static;\n                proxy_pass http://unix:/var/www/${project_name}/${project_name}.sock;\n                proxy_set_header Host \$host;\n                proxy_set_header X-Real-IP \$remote_addr;\n                proxy_redirect off;\n        }\n}" > /etc/nginx/sites-available/${project_name}
  sudo ln -s /etc/nginx/sites-available/${project_name} /etc/nginx/sites-enabled 
  sudo nginx -t
}

open_nginx_ports() {
  sudo ufw allow 80
  sudo ufw allow 443
  sudo ufw allow $application_port
  sudo ufw allow 'Nginx Full'
}
config_certbot() {
  sudo apt install python3-certbot-nginx
  sudo certbot --nginx -d ${domain_name} -d www.${domain_name}
}

load_application() {
  sudo ufw delete allow 'Nginx HTTP'
  sudo systemctl restart nginx
}

proj_name;
site_name;
get_port;
install_dependancies;
setup_venv;
create_wsgi_file
create_service_file
start_service
create_nginx_files;
open_nginx_ports;
config_certbot
load_application;
