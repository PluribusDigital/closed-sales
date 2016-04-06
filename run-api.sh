#!/bin/sh

docker rmi $(docker images -f "dangling=true" -q)

docker build -t stsilabs/closed-sales-web /home/vagrant && \

docker run -it -p "8080:3000" stsilabs/closed-sales-web

docker stop $(docker ps -q -a) && docker rm $(docker ps -a -q)

#-v "/home/vagrant/public/app/client:/wwwroot/client" \
