## v0.8.0 - 2025-11-16

### Changed
- **BREAKING:** Upgraded minimum Ruby version to 3.1.0+
- **BREAKING:** Upgraded Rails dependency to 7.0.0+
- Updated Nokogiri to ~> 1.13.0 (was ~> 1.11.0) for HTML4 support
- Updated BSON to ~> 4.15 (was 4.4.2)
- Updated Psych to ~> 5.0 (was ~> 3.3)
- Updated Mongoid development dependency to ~> 7.5
- Removed classic autoloader (Rails 7 uses zeitwerk by default)

### Added
- Added automatic logger require injection in boot.rb for Ruby 3.1+ compatibility
- Added Rails 7 configuration support in generators
- Added assets manifest.js template for Rails 7 asset pipeline
- Added Ruby 3.1.2 and Rails 7.0.0 to README prerequisites

### Fixed
- Fixed Logger constant error with Ruby 2.7.6+ and Rails 6.1+
- Fixed Nokogiri::HTML4 constant missing error
- Fixed duplicate gem entries in Gemfile generation
- Fixed asset precompilation issues in Rails 7
- Fixed social login compatibility issues

### Notes
- Applications using Jinda 0.8.0 must use Ruby 3.1.0+ and Rails 7.0+
- For older Ruby/Rails versions, use Jinda 0.7.x
- Test thoroughly after upgrading from 0.7.x

## v0.7.7.2
# config with Jenkins

## v0.7.6.0
# fixed test gem

## v0.7.5.5
# fixed mongoid for rails-6.1.3

## v0.7.5.4

# Replace gem 'mongoid'

## v0.7.5.3

# Fix Article report, admin icon

# Fixed rexml issue in Rails-6.1.3

## v0.7.5.2

# Fix Article report, admin icon

## v0.7.5.0

# Reinstall jinda Ok

## v0.7.4.1

# Fixed required pry

## v0.7.4

# Add check for gem before install

## v0.7.3

# rescue ruby 2.7 in markdown''

## v0.7.1.2

# Fixed comment / user info

## v0.7.1.0

# support Rails 6.1

# fixed bug mongoid 7.2.0 using git@github.com:kul1/mongoid.git'
