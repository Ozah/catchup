class StaticPagesController < ApplicationController
  def start
    redirect_to current_user if signed_in?
  end

  def new_catchup

  end

  def help
  	
  end

end
