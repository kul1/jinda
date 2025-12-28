#!/bin/bash
set -e

echo "Creating test app..."
cd ~/tmp/jinda_tests
rails new test_quick --skip-test --skip-bundle --skip-active-record
cd test_quick

echo "Adding Jinda..."
echo "gem 'jinda', path: '~/mygem/jinda'" >> Gemfile

echo "Bundle install..."
bundle install

echo "Running jinda:install..."
rails generate jinda:install

echo "Checking files..."
ls -la app/controllers/ | grep admins && echo "✓ Controllers created" || echo "✗ Controllers missing"
