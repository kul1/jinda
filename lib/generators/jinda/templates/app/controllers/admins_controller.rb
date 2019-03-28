class AdminsController < ApplicationController
  def update_role
    user = Jinda::User.find_by :code=> $xvars["select_user"]["code"]
    user.update_attribute :role, $xvars["edit_role"]["role"]
  end
end
