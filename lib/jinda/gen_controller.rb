# frozen_string_literal: true

def process_controllers
  process_services
  modules = Jinda::Module.all
  modules.each do |m|
    next if controller_exists?(m.code)

    system("rails generate controller #{m.code}")
  end
end
