#!/usr/bin/env bash

apt-get update -y
apt-get install -y nginx

sed -i 's/listen 80 default_server;/listen 82 default_server;/' /etc/nginx/sites-available/default

cat >/var/www/html/index.nginx-debian.html <<'HTML'
<!doctype html>
<html lang="uk">
<head>
  <meta charset="utf-8">
  <title>Lab: Nginx на 82 порту</title>
</head>
<body>
  <h1>Вітаю! Nginx працює на порту 82</h1>
</body>
</html>
HTML

systemctl restart nginx
systemctl enable nginx
