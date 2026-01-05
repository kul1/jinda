# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    code { Faker::Name.unique.name }
    email { Faker::Internet.email }
    role { 'Admin' }
  end
  factory :note, class: 'Note' do
    title { Faker::Lorem.sentence[0..29] }
    body { Faker::Lorem.sentence[0..999] }
    association :user
  end
end
