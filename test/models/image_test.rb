require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test for the overal validity of a properly constructed image
  test 'valid image' do
    image = make_valid_image
    assert image.valid?
  end

  test 'fixture count' do
    assert_equal 2, Image.count
  end

  test 'all fixtures must have valid urls' do
    Image.all.each do |image|
      assert image.valid?, "Invalid image fixture found: #{image.url}"
    end
  end

  test 'URL cant be blank' do
    image = Image.new
    image.valid?

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

  test 'can add tag' do
    image = make_valid_image
    image.tag_list.add('test tag')
    image.save

    assert_equal 1, Image.tagged_with('test tag').count
  end

  test 'can remove tag' do
    image = make_valid_image
    image.tag_list.add('test tag')
    image.save

    image.tag_list.remove('test tag')
    image.save

    assert_equal 0, Image.tagged_with('test tag').count
  end

  test 'can add multiple tags as one string' do
    image = make_valid_image
    image.tag_list = 'tag1, tag2, tag3'

    assert_equal 3, image.tag_list.count
  end

  private

  def make_valid_image
    Image.new(url: 'http://validsite.com/validimage.png')
  end

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
