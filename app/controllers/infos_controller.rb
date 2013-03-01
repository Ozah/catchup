class InfosController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy

  def index

  end

  def new
    @info = Info.new
  end

  def create
    @info = current_user.infos.build(params[:info])
    if @info.save
      flash[:success] = "Link added!"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def destroy
    @info.destroy
    redirect_to current_user
  end

  private

    def correct_user
      @info = current_user.infos.find_by_id(params[:id])
      redirect_to current_user if @info.nil?
    end
end