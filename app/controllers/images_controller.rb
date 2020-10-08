class ImagesController < ApplicationController
  def new
  end

  def create
    render plain: params[:image].inspect
  end
end
