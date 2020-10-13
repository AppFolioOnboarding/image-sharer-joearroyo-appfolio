require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test for the overal validity of a properly constructed image
  test 'valid image' do
    image = Image.new(url: 'http://validsite.com/validimage.png')
    assert image.valid?
  end

  test 'URL cant be blank' do
    image = Image.new
    image.valid?

    # image url should fail the presence validator specifically
    assert ErrorHelper.error_for_validation(image, :url, :blank)

    # This only tests whether there is something in the url attribute,
    # so purposefully putting an invalid url here
    image.url = 'testurl'
    image.valid?

    refute ErrorHelper.error_for_validation(image, :url, :blank)
  end

  test 'URL must be formatted properly' do
    image = Image.new
    [nil, 'invalidurl', 'invalidurl.what', 'www.invalidurl'].each do |invalid_url|
      image.url = invalid_url
      image.valid?
      assert ErrorHelper.error_for_validation(image, :url, :invalid_url_format)
    end

    ['http://testing.com/image.jpg', 'https://testing.com/image.png'].each do |valid_url|
      image.url = valid_url
      image.valid?
      refute ErrorHelper.error_for_validation(image, :url, :invalid_url_format)
    end
  end

  test 'URL must have an image name before its extension' do
    image = Image.new
    image.url = '.png'
    image.valid?
    assert ErrorHelper.error_for_validation(image, :url, :invalid),
           'empty image names should not be allowed, even if they contain a proper extension'
  end

  test 'URL must have proper image extension' do
    image = Image.new

    perform_url_test(false, image, 'image.blah', :invalid, 'invalid image extension should not pass')
    perform_url_test(true, image, 'image.png', :invalid, 'png extension was rejected')
    perform_url_test(true, image, 'image.PNG', :invalid, 'extensions should not be case sensitive')
    perform_url_test(true, image, 'image.jpg', :invalid, 'jpg extension was rejected')
    perform_url_test(true, image, 'image.gif', :invalid, 'gif extension was rejected')
    perform_url_test(true, image, 'image.tiff', :invalid, 'tiff extension was rejected')
  end

  private

  def perform_url_test(expect_success, image, url, validation, error_msg)
    image.url = url
    image.valid?
    if expect_success
      refute ErrorHelper.error_for_validation(image, :url, validation), error_msg
    else
      assert ErrorHelper.error_for_validation(image, :url, validation), error_msg
    end
  end
end
