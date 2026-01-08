# frozen_string_literal: true

class Jinda::JindaModule
  begin
    include Mongoid::Document
    puts "Included Mongoid"
  rescue => e
    puts "Error including Mongoid: #{e}"
  end
  puts "JindaModule loaded"

  field :uid, type: String
  field :code, type: String
  field :name, type: String
  field :role, type: String
  field :seq, type: Integer
  field :icon, type: String

  has_many :services, class_name: 'Jinda::Service', inverse_of: :jinda_module
end
