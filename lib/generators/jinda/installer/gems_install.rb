# frozen_string_literal: true

def setup_gems
  #         # define required gems: jinda_gem, jinda_dev_gem
  jinda_gem        =
    [
      ['bson', '4.4.2'],
      ['maruku', '~> 0.7.3'],
      ['bcrypt'],
      ['rouge'],
      ['normalize-rails'],
      ['font-awesome-rails'],
      ['font-awesome-sass', '~> 5.12.0'],
      ['meta-tags'],
      ['jquery-turbolinks', '2.1.0'],
      ['mongo', '2.11.3'],
      ['turbolinks_render'],
      ['haml-rails', '~> 2.0.1'],
      ['haml', '~> 5.1', '>= 5.1.2'],
      ['mail'],
      ['prawn'],
      ['redcarpet'],
      ['oauth2', '1.4.4'],
      ['omniauth', '1.9.1'],
      ['omniauth-oauth2', '1.6.0'],
      ['omniauth-identity', '~> 1.1.1'],
      ['omniauth-facebook', '6.0.0'],
      ['omniauth-google-oauth2', '0.8.0'],
      ['dotenv-rails'],
      ['cloudinary', '1.13.2'],
      ['kaminari', '1.2.0'],
      ['jquery-rails', '4.3.5']
    ]
  jinda_custom_gem =
    [
      ['mongoid-paperclip', { require: 'mongoid_paperclip' }],
      ['kaminari-mongoid', '1.0.1'],
      ['nokogiri', '~> 1.11.0'],
      ['mongoid', { git: 'git@github.com:kul1/mongoid-jinda.git' }]
      # ["mongoid", "~> 7.1.0"]
    ]
  jinda_dev_gem    =
    [
      ['shoulda'],
      ['rspec'],
      ['rspec-rails'],
      ['better_errors'],
      ['binding_of_caller'],
      ['pry-byebug'],
      ['factory_bot_rails'],
      ['database_cleaner'],
      ['guard'],
      ['guard-rspec'],
      ['guard-minitest'],
      ['capybara'],
      ['selenium-webdriver'],
      ['rb-fsevent'],
      ['valid_attribute'],
      ['faker']
    ]

  # Check each jinda_gem and create new array if found one otherwise just create.
  # Open Gemfile add gem if not exist
  jinda_gem.each do |g|
    if `gem list -e --no-versions #{g[0]}` == "#{g[0]}\n"
      if g.count == 2
        xgem_0 = `gem list -e #{g[0]}`
        if xgem_0.include?(g[1].to_s.gsub(/[~> ]/, ''))
          # puts "     Checking #{g[0]} found Ver. #{g[1]} already exist in Gemfile", :green
          Rails.logger.debug { "     Checking #{g[0]} found Ver. #{g[1]} already exist in Gemfile" }
        else
          # puts "    Found existing #{xgem_0} in Gemfile or System, Please edit Gemfile", :red
          Rails.logger.debug { "    Found existing #{xgem_0} in Gemfile or System, Please edit Gemfile" }
          gem g[0], g[1]
        end
      end
      # puts "     SKIP adding #{g[0]} in Gemfile", :yellow
      Rails.logger.debug { "     SKIP adding #{g[0]} in Gemfile" }
    elsif g.count == 2
      gem g[0], g[1]
    else
      gem g[0]
    end
  end

  # create list of gem in sub-group dev and test
  jinda_dev_new = []
  jinda_dev_gem.each do |g|
    if `gem list -e --no-versions #{g[0]}` == "#{g[0]}\n"
      # puts "     #{g[0]} already exist in Gemfile", :yellow
      Rails.logger.debug { "     #{g[0]} already exist in Gemfile" }
    else
      jinda_dev_new << g
    end
  end
  unless jinda_dev_new.none?
    gem_group :development, :test do
      jinda_dev_new.each do |n|
        if n.one?
          gem n[0]
        else
          gem n[0], n[1]
        end
      end
    end
  end

  # create list of custom gem
  jinda_custom_new = []
  jinda_custom_gem.each do |g|
    # unless (%x(gem list -e --no-versions #{g[0]})) == "#{g[0]}\n"
    if File.read('Gemfile').include?("#{g[0]}, #{g[1]}")
      Rails.logger.debug "     #{g[0]} already exist in Gemfile", :yellow
      Rails.logger.debug "     #{g[0]} already exist in Gemfile", :yellow
    else
      jinda_custom_new << g
    end
  end
  return if jinda_custom_new.none?

  jinda_custom_new.each do |c|
    # puts "     Checking if #{c[0]} already exist in Gemfile", :yellow
    Rails.logger.debug { "     Checking if #{c[0]} already exist in Gemfile" }
    if c.one?
      gem c[0]
    else
      gem c[0], c[1]
    end
  end
end
