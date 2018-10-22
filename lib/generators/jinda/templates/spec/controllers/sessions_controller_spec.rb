# essions_controller_spec.rb
require 'spec_helper'

describe SessionsController do

	describe "Google" do

		before do
			request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
		end

		describe "#create" do

			it "should successfully create a user" do
				expect {
					post :create, params: {provider: :google_oauth2}
				}.to change{ Jinda::User.count }.by(1)
			end

			it "should successfully create a session" do
				session[:user_id].should be_nil
				post :create, params: {provider: :google_oauth2}
				session[:user_id].should_not be_nil
			end

			it "should redirect the user to the articles/my url" do
				post :create, params: {provider: :google_oauth2}
				response.should redirect_to articles_my_path
			end

		end

		describe "#destroy", js: true  do
			before do
				post :create, params: {provider: :google_oauth2}
			end

			it "should clear the session" do
				session[:user_id].should_not be_nil
				delete :destroy
				session[:user_id].should be_nil
			end

			it "should redirect to the home page" do
				delete :destroy
				# response.should redirect_to root_url
				# https://stackoverflow.com/questions/5144758/how-to-test-a-javascript-redirect-with-rspec
				response.body.should include("window.location")
			end
		end
	end

	describe "Facebook" do

		before do
			request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
		end

		describe "#create" do

			it "should successfully create a user" do
				expect {
					post :create, params: {provider: :facebook}
				}.to change{ Jinda::User.count }.by(1)
			end

			it "should successfully create a session" do
				session[:user_id].should be_nil
				post :create, params: {provider: :facebook}
				session[:user_id].should_not be_nil
			end

			it "should redirect the user to the articles/my url" do
				post :create, params: {provider: :facebook}
				response.should redirect_to articles_my_path
			end

		end

		describe "#destroy", js: true  do
			before do
				post :create, params: {provider: :facebook}
			end

			it "should clear the session" do
				session[:user_id].should_not be_nil
				delete :destroy
				session[:user_id].should be_nil
			end

			it "should redirect to the home page" do
				delete :destroy
				# response.should redirect_to root_url
				# https://stackoverflow.com/questions/5144758/how-to-test-a-javascript-redirect-with-rspec
				response.body.should include("window.location")
			end
		end
	end

end


