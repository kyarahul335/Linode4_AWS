# Deploying to AWS EC2

## Prerequisites
1. AWS Account
2. AWS CLI installed and configured
3. SSH key pair for EC2 access

## Steps to Deploy

### 1. Launch EC2 Instance
1. Go to AWS Console > EC2
2. Click "Launch Instance"
3. Choose Ubuntu Server 22.04 LTS
4. Select t2.micro (free tier eligible) or larger based on your needs
5. Configure Security Group:
   - Allow SSH (Port 22) from your IP
   - Allow HTTP (Port 80) from anywhere
   - Allow HTTPS (Port 443) from anywhere if using SSL
6. Launch instance and download your key pair (.pem file)

### 2. Connect to Your Instance
```bash
chmod 400 your-key.pem
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### 3. Deploy the Application
1. Clone your repository:
```bash
git clone <your-repository-url>
cd linode-manager
```

2. Make the deployment script executable:
```bash
chmod +x deploy.sh
```

3. Run the deployment script:
```bash
./deploy.sh
```

### 4. Verify Deployment
1. Open your browser and navigate to `http://your-ec2-ip`
2. Check service status:
```bash
sudo systemctl status linode-manager
sudo systemctl status nginx
```

### 5. Troubleshooting
- Check application logs:
```bash
sudo journalctl -u linode-manager
```
- Check Nginx logs:
```bash
sudo tail -f /var/log/nginx/error.log
```

### 6. Updating the Application
1. Pull latest changes:
```bash
git pull
```
2. Restart the service:
```bash
sudo systemctl restart linode-manager
```

## Security Considerations
1. Set up SSL/TLS using Let's Encrypt
2. Configure firewall rules
3. Keep system packages updated
4. Use environment variables for sensitive data
5. Regularly backup your database 