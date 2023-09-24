#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Prompt user to choose Docker, Docker Compose, or both
echo "Please choose an option:"
echo "1. Install Docker"
echo "2. Install Docker Compose"
echo "3. Install both Docker and Docker Compose"

read -p "> " option

if [ "$option" == "1" ] || [ "$option" == "3" ]; then
    # Install Docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

if [ "$option" == "2" ] || [ "$option" == "3" ]; then
    # Install Docker Compose
    sudo apt-get install -y docker-compose
fi

# Add the current user to the docker group
sudo groupadd docker
sudo usermod -aG docker $USER

# Prompt user to log out and log back in
echo "Please log out and log back in so that your group membership is re-evaluated."
echo "If you're running Linux in a virtual machine, you may need to restart the VM for changes to take effect."
echo "You can also run the following command to activate group changes:"
echo "$ newgrp docker"
