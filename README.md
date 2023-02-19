# flask_nginx_https
Quickly gets a basic Flask application online and communicating over https.<br>
-Built and tested on Ubuntu 20.04.3 LTS. <br><br>

**BEFORE RUNNING**<br>
-Foward ports 80 and 443 to your machines local ip
-Ensure your domain is online and active via http.<br>
-If you are using CloudFlare or the like for DNS it is likely the domains SSL<br>settings need to be set to FULL.<br><br><br>



<h3>Scripts actions are as such:</h3>
1. Installs Nginx then configures a server block for user specified domains.<br>
2. Creates a project directory along with virtual environment and installs flask to it.<br>
3. Constructs Flask application with a route returning a success message.<br>
4. Installs and runs CertBot to create a certificate and enable https for the entered domains. <br><br><br>

<h3>Note:</h3>
After following the prompts to configure the Flask application and configure SSL the Flask application will run displaying the servers local IP address and active PORT.<br>

The script currently creates no back ups of nginx-configurations.<br>
It is recommended to back up ```/etc/nginx/sites-available/default``` prior to running if Nginx is already installed.<br><br>

**ALWAYS READ SCRIPTS PRIOR TO RUNNING**<br>
```
git clone https://github.com/chparmley/flask_nginx_https.git
cd flask_nginx_https
chmod +x flask_nginx_https.sh
sudo ./flask_nginx_https.sh
```
<br><br>
**AFTER RUNNING**<br>
- By default only the url of the chosen domain will be enabled. To enable extend routes comment out: ```try_files $uri $uri/ =404;```<br>
- The line is located within the domains sever block location field, in the file ```/etc/nginx/sites-avaliable/default```
