FactoryBot.define do
  factory :user, class: User  do
    code {"Tester"}
    email {"tester@test.comm"}
  end
end
