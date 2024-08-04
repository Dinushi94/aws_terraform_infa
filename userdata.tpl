#!/bin/bash

#update
sudo apt-get update -y &&
sudo apt-get install -y \
#install the dependency 
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common &&

#download the docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
sudo apt-get update -y &&
#install docker
sudo sudo apt-get install docker-ce docker-ce-cli containerd.io -y &&
#add ubuntu to docker
sudo usermod -aG docker ubuntu 
#this will add ubuntu the docker group 
#doing this we can run docker command as a ubuntu user 

#we can use this as a template in the future 