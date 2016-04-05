#!/bin/sh

docker rmi $(docker images -f "dangling=true" -q)

docker build -t stsilabs/closed-sales-app -f Dockerfile-app /home/vagrant && \

docker run -it -p "8000:8000" \
-v "/home/vagrant/public/app/client:/wwwroot/client" \
stsilabs/closed-sales-app

docker stop $(docker ps -q -a) && docker rm $(docker ps -a -q)
