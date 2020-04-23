
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
    
    server_name  _;
    location /user {
      proxy_pass "http://$SERVER_A_ADDRESS/";
    }
    location /admin {
      proxy_pass "http://$SERVER_B_ADDRESS/";
    }
    
  }
}
EOF

echo "SET NGINX CONFIG"
sudo mv /tmp/default.conf /etc/nginx/nginx.conf

echo "RESTART NGINX"
sudo systemctl restart nginx