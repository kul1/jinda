require 'jinda'
require 'jinda/helpers'
include Jinda::Helpers

@btext= "# jinda begin"
@etext= "# jinda end"

namespace :jinda do
  desc "generate models from mm"
  task :update=> :environment do
    @app= get_app
    process_models
    process_controllers
    gen_views
  end

  desc "generate admin user"
  task :seed=> :environment do
    usamples  = [
      { code: 'admin', password: 'secret', email: 'admin@test.com', role: 'M,A,D', image: 'https://user-images.githubusercontent.com/3953832/110025024-7911b480-7cf4-11eb-83ee-8dbe6e8fc96f.png'},
      { code: 'tester', password: 'password', email: 'tester@test.com', role: 'M', image: 'https://www.manateeschools.net/cms/lib/FL02202357/Centricity/domain/2439/staff_photos/fflinststone.jpg'}
    ]
    usamples.each do |h|
      code  = h[:code].to_s
      email = h[:email].to_s
      password = h[:password].to_s
      role = h[:role].to_s
      image = h[:image]
      unless Identity.where(code: code).exists?
        identity= Identity.create :code => code, :email => email, :password => password , :password_confirmation => password
        User.create :provider => "identity", :uid => identity.id.to_s, :code => identity.code,:email => identity.email, :role => role, :image => image
      end
    end
  end

  desc "cancel all pending tasks"
  task :cancel=> :environment do
    Jinda::Xmain.update_all "status='X'", "status='I' or status='R'"
  end
end


