sudo apt update
sudo apt -y install nginx

echo '<!doctype html><html><body><h1>Message from HOSTNAME</h1></body></html>' | sudo tee /var/www/html/index.html
sudo sed -i "s/HOSTNAME/$HOSTNAME/g" /var/www/html/index.html