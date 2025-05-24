#!/bin/bash

# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install required system packages
sudo apt-get install -y python3-pip python3-venv nginx

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Create systemd service file
sudo tee /etc/systemd/system/linode-manager.service << EOF
[Unit]
Description=Linode Manager Application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/linode-manager
Environment="PATH=/home/ubuntu/linode-manager/venv/bin"
ExecStart=/home/ubuntu/linode-manager/venv/bin/gunicorn --workers 3 --bind unix:linode-manager.sock -m 007 app:app

[Install]
WantedBy=multi-user.target
EOF

# Configure Nginx
sudo tee /etc/nginx/sites-available/linode-manager << EOF
server {
    listen 80;
    server_name _;

    location / {
        include proxy_params;
        proxy_pass http://unix:/home/ubuntu/linode-manager/linode-manager.sock;
    }
}
EOF

# Enable Nginx configuration
sudo ln -s /etc/nginx/sites-available/linode-manager /etc/nginx/sites-enabled
sudo rm /etc/nginx/sites-enabled/default

# Start and enable services
sudo systemctl start linode-manager
sudo systemctl enable linode-manager
sudo systemctl restart nginx

echo "Deployment completed! Your application should be running at http://your-ec2-ip" 