FROM rails

RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy

#   Set correct environment variables.
ENV HOME /usr/src/app
ENV STATIC $HOME/public/app

# from :onbuild
RUN mkdir -p $HOME
WORKDIR $HOME
COPY Gemfile $HOME/
COPY Gemfile.lock $HOME/
RUN bundle install

RUN mkdir -p $STATIC
WORKDIR $STATIC

# Copy over the javascript installation info
COPY ./public/app/bower.json $STATIC/
COPY ./public/app/.bowerrc $STATIC/

# Add the javascript dependencies
RUN npm install bower --global
RUN bower install

# Copy over the node installation info
COPY ./public/app/package.json $STATIC/

# Add the server-side dependencies
RUN npm install
RUN npm install gulp --global

# copy over the rest of the files
COPY . $HOME

# Now that everything is installed, make it available to everyone
RUN chmod -R 0777 $HOME

WORKDIR $HOME
EXPOSE 3000
CMD ["./run.sh"]
