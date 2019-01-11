class ApplicationController < ActionController::Base
  include Knock::Authenticable
  include Error::ErrorHandler

  skip_before_action :verify_authenticity_token
end
