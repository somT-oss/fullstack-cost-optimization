set -e 

REPO_URL=

DB_NAME=""
DB_USER=""
DB_PASS=""
DB_HOST=""
ENV=""
DB_PORT=
APP_PORT= # 3000

echo "Update server"
sudo apt -y update && sudo apt -y upgrade

sudo apt install -y nodejs
sudo apt install -y npm

TARGET_DIR="fullstack-cost-optimization"

if [ -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR already exists. Skipping clone."
else
  echo "Cloning repo into $TARGET_DIR..."
  sudo git clone "$REPO_URL" "$TARGET_DIR"
fi

cd "$TARGET_DIR"/books-crud-backend 

cat > .env << EOF
DB_HOST=${DB_HOST}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASS}
DB_NAME=${DB_NAME}
DB_PORT=${DB_PORT}
PGHOST=${DB_HOST}
PGUSER=${DB_USER}
PGPASSWORD=${DB_PASSWORD}
PGDATABASE=${DB_NAME}
PGPORT=${DB_PORT}
NODE_ENV=${ENV}
PORT=${APP_PORT}
EOF

npm install package.json
npm run dev