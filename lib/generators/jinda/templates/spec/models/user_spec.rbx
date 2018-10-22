require 'rails_helper'

# RSpec.describe "Jinda::User", :type => :model do
RSpec.describe "Jinda/User", :type => :model do

  before(:all) do
    @user1 = create "Jinda/User"
  end

  it "has a unique code name" do
    user2 = build("Jinda/User", code: "tester", email: "tester@test.com")
    expect(user2).to be_valid
  end

  it "is valid with valid attributes" do
    expect(@user1).to be_valid
  end

  xit "is not valid without a code" do 
    user2 = build("Jinda/User", code: nil)
    expect(user2).to_not be_valid
  end
  
  xit "is not valid without an email" do
    user2 = build("Jinda/User", email: nil)
    expect(user2).to_not be_valid
  end

end

