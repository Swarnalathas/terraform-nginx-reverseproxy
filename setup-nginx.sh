#!/bin/sh

echo "CREATE NGINX CONFIG TEMPLATE"
cat > /tmp/default.conf <<EOF
worker_processes  1;
events {
    worker_connections  1024;
}
http {
  include       mime.types;
  default_type  application/octet-stream;
  sendfile        on;
  keepalive_timeout  65;
  server {
    listen 80;
    location /admin {
      proxy_pass http://$SERVER_A/;;
    }
    location /user {
      proxy_pass http://$SERVER_B/;
    }
  }
}
EOF

echo "SET NGINX CONFIG"
sudo mv /tmp/default.conf /etc/nginx/nginx.conf

echo "RESTART NGINX"
sudo systemctl restart nginx