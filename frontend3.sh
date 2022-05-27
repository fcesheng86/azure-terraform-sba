#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run -d --name react -p 80:80 wengjiancong1994/react-nginx-demo:1.0.0