#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${DB_HOST:-192.168.56.10}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-petclinic}"
DB_USER="${DB_USER:-petuser}"
DB_PASS="${DB_PASS:-petpass}"

export DEBIAN_FRONTEND=noninteractive

echo "=== 1) Installing MySQL ==="
apt-get update -y
apt-get install -y mysql-server ufw

echo "=== 2) Allow MySQL listening all intefaces  ==="
MYSQL_CNF="/etc/mysql/mysql.conf.d/mysqld.cnf"
if grep -q "^bind-address" "$MYSQL_CNF"; then
  sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" "$MYSQL_CNF"
else
  echo "bind-address = 0.0.0.0" >> "$MYSQL_CNF"
fi
systemctl restart mysql

echo "=== 3) Setup firewall: MySQL and allow only 192.168.56.0/24 ==="
ufw allow from 192.168.56.0/24 to any port ${DB_PORT}
ufw --force enable

echo "=== 4) Creating DB and user ==="
mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "=== DB_VM provisioning done ==="

