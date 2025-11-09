
set -e
echo "=== Graylog Automated Installation Starting ==="

# --- A. SERVER PREPARATION ---
echo "[1/8] Updating server packages..."
sudo apt update && sudo apt upgrade -y

echo "[2/8] Setting hostname..."
sudo hostnamectl set-hostname log-server

# --- B. OPTION 1 – INSTALLING GRAYLOG ---
echo "[3/8] Installing Java and dependencies..."
sudo apt install -y openjdk-11-jre-headless uuid-runtime pwgen gnupg curl wget apt-transport-https

echo "[4/8] Installing MongoDB..."
sudo apt install -y mongodb
sudo systemctl enable --now mongodb

echo "[5/8] Installing Elasticsearch..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install -y elasticsearch

# Configure Elasticsearch
sudo sed -i '/^#\?cluster.name:/c\cluster.name: graylog' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/^#\?action.auto_create_index:/c\action.auto_create_index: false' /etc/elasticsearch/elasticsearch.yml
sudo systemctl enable --now elasticsearch

echo "[6/8] Installing Graylog server..."
wget https://packages.graylog2.org/repo/packages/graylog-5.0-repository_latest.deb
sudo dpkg -i graylog-5.0-repository_latest.deb
sudo apt update
sudo apt install -y graylog-server

# --- Graylog Configuration ---
echo "[7/8] Configuring Graylog..."
PASSWORD_SECRET=$(pwgen -N 1 -s 96)
echo "Generated Graylog password secret."
read -sp "Enter Graylog admin password to hash: " ADMIN_PASS
echo
ROOT_PASS_SHA2=$(echo -n "$ADMIN_PASS" | sha256sum | awk '{print $1}')

sudo sed -i "s|^password_secret *=.*|password_secret = $PASSWORD_SECRET|" /etc/graylog/server/server.conf
sudo sed -i "s|^root_password_sha2 *=.*|root_password_sha2 = $ROOT_PASS_SHA2|" /etc/graylog/server/server.conf
sudo sed -i "s|^#http_bind_address *=.*|http_bind_address = 0.0.0.0:9000|" /etc/graylog/server/server.conf

sudo systemctl enable --now graylog-server

echo "[8/8] Installation complete!"
echo "Access Graylog Web Interface at: http://$(hostname -I | awk '{print $1}'):9000"
echo "Default user: admin"
echo "Use the password you entered above."
