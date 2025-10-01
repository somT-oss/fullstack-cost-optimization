#!/bin/bash
# configure-db.sh
# Script to configure PostgreSQL on private EC2

set -e

DB_NAME=""
DB_USER=""
DB_PASS=""

echo "Update server"
sudo apt -y update && sudo apt -y upgrade

echo "Installing postgres16"
sudo apt install -y postgresql
echo "Done installing postgres"


echo "Starting DB configuration..."

# Switch to postgres user and create database and user
sudo -u postgres psql <<EOF
CREATE DATABASE ${DB_NAME};
CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};
ALTER DATABASE ${DB_NAME} OWNER TO ${DB_USER};
EOF

echo "Database ${DB_NAME} configured successfully with user ${DB_USER}"


echo "Editing postgres config files"

# Allow Postgres to listen on all addresses
echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/16/main/postgresql.conf

# Allow connections from your VPC CIDR range (10.0.0.0/16 here)
echo "host all all <vpc cidr> md5" | sudo tee -a /etc/postgresql/16/main/pg_hba.conf

echo "Restarting postgres..."

# Restart PostgreSQL to apply changes
sudo systemctl restart postgresql

echo "Postgres is ready for connection"