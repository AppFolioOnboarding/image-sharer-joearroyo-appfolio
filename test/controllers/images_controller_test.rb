require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get images_path
    assert_response :success
  end

  test "should get new image" do
    get new_image_path
    assert_response :success
  end

  test "should show image" do
    get image_path(images(:one))
  end

  test "should create image url" do

    #attempt to add a new valid url image, the number of images should change due to successfully adding it
    assert_difference('Image.count') do
      post images_url, params: { image: {url: 'http://test.png'} }
    end
    
    #upon success, we should be redirected to the show page for the image that was just created
    assert_redirected_to image_path(Image.last)
  end


end
