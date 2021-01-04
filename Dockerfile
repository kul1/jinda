# https://docs.docker.com/compose/rails/
FROM ruby:2.6.3
RUN apt-get update -qq 
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
# COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install
COPY . /myapp

# Set Rails environment to production
# ENV RAILS_ENV production
ENV RAILS_ENV development
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt install -y nodejs

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# EXPOSE 3000
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
