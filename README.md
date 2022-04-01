# flask_nginx_https
Quickly gets a basic Flask application online with https enabled.<br>
-Built and tested on Ubuntu 20.04.3 LTS. <br><br>

**BEFORE RUNNING**<br>

-Ensure your domain is online and active via https.<br>
-If you are using CloudFlare or the like for DNS it is likely the domains SSL<br>settings need to be set to FULL.<br><br><br>



<h3>Scripts actions are as such:</h3>
1. Installs Nginx then configures a server block for user specified domains.<br>
2. Creates a project directory along with virtual environment and installs flask to it.<br>
3. Constructs Flask application with a route returning a success message.<br>
4. Installs and runs CertBot create a certificate and enable https for the entered domains. <br><br><br>


After following the prompts to configure the Flask application and configure SSL the<br>server will run displaying the servers local IP address and active PORT number.<br>

The script currently creates no back ups of nginx-configurations. It is recommended to back up /etc/nginx/sites-available/default prior to running if Nginx is already installed.<br><br>

**ALWAYS READ SCRIPTS PRIOR TO RUNNING**<br>
```
git clone https://github.com/chparmley/flask_nginx_https.git
chmod +x flask_nginx_https.sh
./flask_nginx_https.sh
```
<br><br>
**AFTER RUNNING**<br>
-By default only the url of the chosen domain will be enabled. To enable extend routes comment out the line: "try_files $uri $uri/ =404;"
  located within the sever blocks location field in the file /etc/nginx/sites-avaliable/default
