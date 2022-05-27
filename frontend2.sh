#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run -d -p 80:3000 --name frontend -e REACT_APP_API_URL=http://20.106.47.68:8080/ wengjiancong1994/react:1.0.2