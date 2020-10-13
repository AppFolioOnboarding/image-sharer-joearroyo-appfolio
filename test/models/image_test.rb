require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test "URL can't be blank" do
    image = Image.new
    image.valid?

    # image url should fail the presence validator specifically
    assert ErrorHelper.has_error_for_validation(image, :url, :blank)

    # This only tests whether there is something in the url attribute,
    # so purposefully putting an invalid url here
    image.url = 'testurl'
    image.valid?

    refute ErrorHelper.has_error_for_validation(image, :url, :blank)
  end

  test 'URL must be formatted properly' do
    image = Image.new
    image.valid?
    assert ErrorHelper.has_error_for_validation(image, :url, :invalid_url_format)

    image.url = 'invalidurl'
    image.valid?
    assert ErrorHelper.has_error_for_validation(image, :url, :invalid_url_format)

    image.url = 'invalidurl.what'
    image.valid?
    assert ErrorHelper.has_error_for_validation(image, :url, :invalid_url_format)

    image.url = 'www.invalidurl'
    image.valid?
    assert ErrorHelper.has_error_for_validation(image, :url, :invalid_url_format)

    image.url = 'http://testing.com/image.jpg'
    image.valid?
    refute ErrorHelper.has_error_for_validation(image, :url, :invalid_url_format),
           'URL is not passing as valid using http prefix'

    image.url = 'https://testing.com/image.png'
    image.valid?
    refute ErrorHelper.has_error_for_validation(image, :url, :invalid_url_format),
           'URL is not passing as valid using https prefix'
  end

  test 'URL must have an image name before its extension' do
    image = Image.new
    image.url = '.png'
    image.valid?
    assert ErrorHelper.has_error_for_validation(image, :url, :invalid),
           'empty image names should not be allowed, even if they contain a proper extension'
  end

  test 'URL must have proper image extension' do
    image = Image.new

    # improper image extension
    image.url = 'image.blah'
    image.valid?
    assert ErrorHelper.has_error_for_validation(image, :url, :invalid)

    image.url = 'image.png'
    image.valid?
    refute ErrorHelper.has_error_for_validation(image, :url, :invalid),
           'png extension was rejected'

    image.url = 'image.PNG'
    image.valid?
    refute ErrorHelper.has_error_for_validation(image, :url, :invalid),
           'extensions should not be case sensitive'

    image.url = 'image.jpg'
    image.valid?
    refute ErrorHelper.has_error_for_validation(image, :url, :invalid),
           'jpg extension was rejected'

    image.url = 'image.gif'
    image.valid?
    refute ErrorHelper.has_error_for_validation(image, :url, :invalid),
           'gif extension was rejected'

    image.url = 'image.tiff'
    image.valid?
    refute ErrorHelper.has_error_for_validation(image, :url, :invalid),
           'tiff extension was rejected'
  end
end
