require 'rails_helper'
RSpec.describe User Test, type: :model do 
  before(:each) do 
    @user = User.create!(user: "test name", email: "email@yahoo.com", code: "12345")
  end

  # describe "creation" do
  # 	it "should have one item created after being created" do 
  # 		expect(User.all.count).to eq(1)
  # 	end
  # end

  describe "email validation" do
  	it "should have one email to create user" do 
  		@user.email = nil
  		expect(@user).to_not be_valid
  	end
  end

  # describe " Check User validates_presence_of :code " do
  # 	it "should not let user be created without a code" do 
  # 		@user.code = nil
  # 		expect(@user).to_not be_valid
  # 	end
  # end
end
