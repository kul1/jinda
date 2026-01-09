# frozen_string_literal: true

module Jinda
  class Role
    include Mongoid::Document
    include Mongoid::Timestamps

    field :code, type: String
    field :name, type: String
    belongs_to :user, class_name: 'User'
  end
end
