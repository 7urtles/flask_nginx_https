# flask_nginx_https
Script to quickly get a basic Flask application online with https enabled.

BEFORE RUNNING!<br>

-Ensure your domain is online and active via https.<br>
-If you are using CloudFlare or something similar for DNS it is likely the domain SSL<br>settings need to be set to FULL.


<h3>Installation process<h3>
The scripts actions are as such:<br>
1. Installs Nginx then configures a server block for user specified domains.<br>
2. Creates a project directory along with virtual environment and installs flask to it.<br>
3. Constructs Flask application with a route returning a success message.<br>
4. Installs and runs CertBot create a certificate and enable https for the entered domains. <br>


After following the prompts to configure the Flask application and run certbot the<br>server will run displaying the servers local IP address and active PORT number.

**ALWAYS READ SCRIPTS PRIOR TO RUNNING**<br>
Usage:<br>
```
git clone.....
chmod +x flask_nginx_https.sh
./flask_nginx_https.sh
```
