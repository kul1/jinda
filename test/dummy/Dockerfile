# Dockerfile for Jinda Rails Application
# This Dockerfile is used with docker-compose-web.yml for full stack deployment
# It copies the entire application and sets up the web container
# For CI/testing, use docker-compose-mongodb.yml for MongoDB only
# Reference: https://docs.docker.com/compose/rails/

FROM ruby:3.3.0
RUN apt-get update -qq 
RUN mkdir /myapp
WORKDIR /myapp

# Copy dependency files first for better layer caching
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY vendor /myapp/vendor

# Install bundler and dependencies
RUN gem install bundler:2.4.10
RUN bundle install

# Copy entire application (for full deployment)
COPY . /myapp

# Set Rails environment to production
# ENV RAILS_ENV production
# RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
#    && apt install -y nodejs

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
