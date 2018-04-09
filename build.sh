#!/bin/bash

docker build --tag bosenok/1c-server .

docker push bosenok/1c-server
docker pull bosenok/1c-server
echo 'Starting bosenok/1c-server'
bash run.sh

