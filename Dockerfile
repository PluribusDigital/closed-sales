FROM rails

#   Set correct environment variables.
ENV HOME /usr/src/app

# from :onbuild
RUN mkdir -p $HOME
WORKDIR $HOME
COPY Gemfile $HOME
COPY Gemfile.lock $HOME
RUN bundle install
COPY . $HOME

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
