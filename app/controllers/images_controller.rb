class ImagesController < ApplicationController
  def index
    @images = all_images_ordered
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
      redirect_to @image, notice: 'Image added successfully'
    else
      flash[:alert] = 'Image creation failed'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    Image.destroy(params[:id])
    redirect_to images_path
  end

  def tag_search
    @images = Image.tagged_with(params[:tag]).order(created_at: :desc)

    # if the tag search is unsuccesfull we'll currently fall back to displaying all images
    @images = all_images_ordered if @images.empty?
  end

  private

  def all_images_ordered
    Image.order(created_at: :desc)
  end

  def image_params
    params.require(:image).permit(:url, :tag_list)
  end
end
