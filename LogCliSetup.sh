
set -e
echo "=== Filebeat Automated Installation Starting ==="
sudo apt-get install apt-transport-https

echo "[1/3] Installing Filebeat..."
echo "Adding Elastic GPG key..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "[2/3] Adding Filebeat APT repository..."
echo "deb https://artifacts.elastic.co/packages/9.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-9.x.list

echo "[3/3] Installing Filebeat..."
sudo apt-get update && sudo apt-get install filebeat

echo "ayoko na config mo na si output filebeat.yml"