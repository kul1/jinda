# frozen_string_literal: true

class IdentitiesController < ApplicationController
  def new
    @identity = request.env['omniauth.identity']
  end
end
