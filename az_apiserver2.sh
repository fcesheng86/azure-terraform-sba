#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run -d -p 8080:8080 --name apiserver -e spring.datasource.url=jdbc:postgresql://smartbankapp.postgres.database.azure.com:5432/smartbankapp -e spring.datasource.password=Jupiter@123 -e spring.datasource.username=postgres 963128/smartbank-apiserver:v1