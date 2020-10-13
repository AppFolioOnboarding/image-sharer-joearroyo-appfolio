require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get images_path
    assert_response :success
  end

  test 'should get new image' do
    get new_image_path
    assert_response :success
  end

  test 'should show image' do
    get image_path(images(:one))
  end

  test 'should create image url' do
    assert_difference('Image.count') do
      post images_url, params: { image: { url: 'http://test.png' } }
    end

    assert_redirected_to image_path(Image.last)
  end
end
