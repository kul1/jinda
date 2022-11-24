#!/bin/bash
set -e
# change mongoid.yml for docker
cp /myapp/config/mongoid.yml-docker /myapp/config/mongoid.yml
# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid
# Compile the assets
bundle exec rake assets:precompile
# Add admin user
# rake db:seed
rake jinda:seed
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
