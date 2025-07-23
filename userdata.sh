#!/bin/bash

# Update and install basic tools
apt update -y
apt install -y curl software-properties-common

# Install Node.js 18.x and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs git

# Create app directory
mkdir -p /home/ubuntu/app

# Download index.js from GitHub (includes CSS and logic)
curl -o /home/ubuntu/app/index.js https://raw.githubusercontent.com/jas9reetctf/ssrf-node-app/refs/heads/main/index.js

# Go to app directory
cd /home/ubuntu/app

# Initialize and install dependencies
npm init -y
npm install express axios needle command-line-args

# Run the app in the background
nohup node index.js > app.log 2>&1 &
