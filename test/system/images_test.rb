require 'application_system_test_case'

class ImagesTest < ApplicationSystemTestCase
  def test_create
    index_page = Images::IndexPage.visit
    new_page = index_page.add_new_image!

    image_tags = 'gif, halloween, skeleton, covid, mask'
    show_page = new_page.create_image!(image_url, image_tags)
    assert show_page.url_on_page?(image_url)
    assert show_page.tags_on_page?(image_tags)

    index_page = show_page.go_back_to_index!
    assert index_page.image_on_page?(image_url)
  end

  def test_delete
    # create an image then delete this specific image and assert that it is no longer on the page
    index_page = Images::IndexPage.visit
    new_page = index_page.add_new_image!
    new_page.create_image!(image_url, '')

    index_page = Images::IndexPage.visit
    index_page.delete_first_image
    assert_not index_page.image_on_page?(image_url)
  end

  def image_url
    'https://media.giphy.com/media/S6BMxdMGjIUHxcXZ3i/giphy.gif'
  end
end
