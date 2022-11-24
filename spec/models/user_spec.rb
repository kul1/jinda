require 'rails_helper'

RSpec.describe "User", :type => :model do
  it "prevents duplicates " do
		user1 = create(:user, code: 'abc', email: 'test@email.com')
		user2 = build(:user, code: 'abc', email: 'test@email.com')

		user1.should be_valid
		#user2.should be_valid
		user2.should_not  have_valid(:code)
	end
end
