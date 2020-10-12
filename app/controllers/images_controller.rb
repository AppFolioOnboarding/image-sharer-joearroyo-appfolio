class ImagesController < ApplicationController
  def index
    #retrieve images sorted such that the newest ones are displayed first
    @images = Image.order(created_at: :desc)
  end
  
  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to @image
    else
      render 'new'
    end
  end

  private

  def image_params
    params.require(:image).permit(:url)
  end
end
