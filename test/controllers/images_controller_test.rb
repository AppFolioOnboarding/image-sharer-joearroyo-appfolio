require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:one)
  end

  def test_index
    get images_path
    assert_response :success
    assert_select 'table.image-index'
  end

  def test_show
    get image_path(@image)

    assert_response :success
    assert_select 'img[src=?]', @image.url
  end

  def test_new
    get new_image_path

    assert_response :success
    assert_select 'form[action=\/images]'
  end

  def test_create__succeed
    assert_difference('Image.count', 1) do
      post images_path, params: { image: { url: 'http://test.png' } }
    end

    assert_redirected_to image_path(Image.last)
  end

  def test_create__fail
    assert_no_difference('Image.count') do
      post images_path, params: { image: { url: 'invalid url' } }
    end

    assert_response :unprocessable_entity
    assert_select 'li', /Invalid image extension/
  end
end
