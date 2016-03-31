FROM mhart/alpine-node:4.2

# Install Node/Bower dependencies
RUN apk add --update git python make g++

ENV HOME /wwwroot
RUN mkdir $HOME
WORKDIR $HOME

# Copy over the javascript installation info
COPY ./public/app/bower.json $HOME/
COPY ./public/app/.bowerrc $HOME/

# Add the javascript dependencies
RUN npm install bower --global
RUN bower install

# Copy over the node installation info
COPY ./public/app/package.json $HOME/

# Add the server-side dependencies
RUN npm install

# Copy over the data
COPY ./data $HOME/api/

# Copy over the rest of the directory
COPY ./public/app/gulpfile.js $HOME/
COPY ./public/app/client $HOME/client

# Now that everything is installed, make it available to everyone
RUN chmod -R 0777 $HOME

# Watch the directories and run the web-server
EXPOSE 8000
CMD ["npm", "start"]
