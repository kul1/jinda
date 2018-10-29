FactoryBot.define do
  factory :user, class: Jinda::User  do
    code {"Tester"}
    email {"tester@test.comm"}
  end
end
