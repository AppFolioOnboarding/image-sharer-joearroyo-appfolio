require 'application_system_test_case'

class ImagesTest < ApplicationSystemTestCase
  test 'add an image' do
    visit images_url

    assert_selector 'a', text: 'Add an Image'

    click_on 'Add an Image'

    fill_in 'image[url]', with: 'https://media.giphy.com/media/S6BMxdMGjIUHxcXZ3i/giphy.gif'
    fill_in 'image[tag_list]', with: 'gif, halloween, skeleton, covid, mask'

    click_on 'Save Image'

    assert_selector 'img'
    assert_text 'gif'
  end
end
