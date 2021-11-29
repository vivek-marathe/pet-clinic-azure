#!/bin/bash
set -x
UNIX_USER=azure
AZ_REPO=$(lsb_release -cs)

sudo apt-get update
sudo apt update

sudo apt-get install -y curl
sudo apt-get install -y build-essential
sudo apt-get install -y unzip
sudo apt-get install -y make
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y apt-transport-https
sudo apt-get install -y lsb-release
sudo apt-get install -y gnupg

sudo apt-get install -y libssl-dev
sudo apt-get install -y libffi-dev
sudo apt-get install -y python-dev

sudo apt-get install -y ca-certificates 
sudo apt-get install -y software-properties-common

# Upgrade all packages that have available updates and remove old ones.
sudo apt-get update
sudo apt -y upgrade
sudo apt autoremove --assume-yes

# Install git
sudo apt install -y git

# install jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c "echo \"deb http://pkg.jenkins.io/debian-stable binary/\" > /etc/apt/sources.list.d/jenkins.list"
sudo apt-get update
sudo apt install -y jenkins

sudo sh -c 'echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
sudo systemctl enable jenkins

# Install azcli # curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

sudo sh -c "echo \"deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ ${AZ_REPO} main\" > /etc/apt/sources.list.d/azure-cli.list"
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor |  sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
sudo apt-get update
date
sudo apt-get install -y azure-cli
date

## install docker

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${AZ_REPO} stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker ${UNIX_USER}
sudo usermod -aG docker jenkins
sudo systemctl enable docker

## install ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

echo 
echo
az --version 2>/dev/null
docker version 2>/dev/null
ansible --version 2>/dev/null
git --version 2>/dev/null
echo
echo