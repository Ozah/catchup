class ApplicationController < ActionController::Base
  protect_from_forgery
  #helpers are by default available views but not in controllers
  include SessionsHelper
end
