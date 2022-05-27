#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run -d -p 80:3000 --name frontend -e REACT_APP_API_URL=http://20.102.48.247:8080/ abhay1813/finalfrontend
