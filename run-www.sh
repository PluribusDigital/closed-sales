#!/bin/sh

docker rmi $(docker images -f "dangling=true" -q)

docker build -t stsilabs/closed-sales /home/vagrant && \

docker run -it -p "8080:8000" \
-v "/home/vagrant/public/app/client:/wwwroot/client" \
stsilabs/closed-sales

docker stop $(docker ps -q -a) && docker rm $(docker ps -a -q)
