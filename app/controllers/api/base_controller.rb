class Api::BaseController < ApplicationController
  include ActionController::ImplicitRender
  include Api::ApiRender
  include DeviseTokenAuth::Concerns::SetUserByToken
  include SecureController
  include Pagy::Backend
end
