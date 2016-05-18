#!/bin/sh

docker rmi $(docker images -f "dangling=true" -q)

docker build -t stsilabs/closed-sales-web:manual /home/vagrant && \

docker run -d -p "5432:5432" \
--env-file /home/vagrant/.env \
--name db postgres && \

docker run -it -p "8080:3000" \
--link db:db  \
--env-file /home/vagrant/.env \
stsilabs/closed-sales-web:manual

docker stop $(docker ps -q -a) && docker rm $(docker ps -a -q)

#-v "/home/vagrant/public/app/client:/wwwroot/client" \
