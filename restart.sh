#!/bin/bash -xe

echo y | docker container prune
echo y | docker network prune
echo y | docker volume prune
docker ps -q |xargs -l -i docker rm --force {}
docker-compose down
sudo rm -rf CA/*
sudo rm -rf serveur/config/*
docker-compose up --build -d --remove-orphans 
