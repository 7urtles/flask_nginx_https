# flask_nginx_https
Script to quickly get a basic Flask application online with https enabled.

BEFORE RUNNING!
-Ensure your domain is online and active via https.
-If you are using CloudFlare or something similar for DNS it is likely the domain SSL
 settings need to be set to FULL.
------------

<h3>Installation process<h3>
The scripts actions are as such:
1. Installs Nginx then configures a server block for user specified domains.
2. Creates a project directory along with virtual environment and installs flask to it.
3. Constructs Flask application with a route returning a success message.
4. Installs and runs CertBot create a certificate and enable https for the entered domains. 


After following the prompts to configure the Flask application and run certbot the
server will run displaying the servers local IP address and active PORT number.

**ALWAYS READ SCRIPTS BEFORE RUNNING!!!**
To run:
```
git clone.....
chmod +x flask_nginx_https.sh
./flask_nginx_https.sh
```
