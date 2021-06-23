#!/bin/bash

set -e


curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


#Install programs
sudo apt-get -y update
sudo apt-get -y install nginx nodejs git


# Install pm2
sudo npm install -g pm2


#clone application
git clone https://github.com/Azure-Samples/nodejs-docs-hello-world.git

sudo pm2 start -f nodejs-docs-hello-world/index.js

#entrer en mode root
sudo chmod 777 /etc/nginx/sites-available/default

#configure nginx
echo "server {
        listen 80;
        location / {
          proxy_pass http://localhost:1337/;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection keep-alive;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
        }
      }" > /etc/nginx/sites-available/default

#Quitter le root
exit

#Restart du service nginx
sudo systemctl restart nginx