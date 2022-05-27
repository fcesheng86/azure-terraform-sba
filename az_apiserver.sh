#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run --name postgres -p 5432:5432 -d -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=smartbankapp postgres
sudo docker run -d -p 8080:8080 --link postgres:dbserver --name apiserver -e spring.datasource.url=jdbc:postgresql://dbserver:5432/smartbankapp 963128/smartbank-apiserver:v1