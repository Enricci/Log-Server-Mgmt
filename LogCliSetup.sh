
set -e
echo "=== Filebeat Automated Installation Starting ==="
sudo apt-get install apt-transport-https

echo "[1/5] Installing Filebeat..."
echo "Adding Elastic GPG key..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "[2/5] Adding Filebeat APT repository..."
echo "deb https://artifacts.elastic.co/packages/9.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-9.x.list

echo "[3/5] Installing Filebeat..."
sudo apt-get update && sudo apt-get install filebeat

echo "[4/5] Configuring Filebeat..."
sudo systemctl enable filebeat

echo "[5/5] Starting Filebeat..."
sudo systemctl start filebeat

echo "ayoko na"