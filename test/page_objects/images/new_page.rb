module Images
  class NewPage < AePageObjects::Document
    path :new_image
    path :images # from failed create

    form_for :image, locator: '.js-image-form' do
      element :url, locator: '.js-image-url'
      element :tag_list, locator: '.js-image-tags'
    end

    def create_image!(image_address, tags)
      url.set(image_address)
      tag_list.set(tags)
      submit_new_image_form!
    end

    def submit_new_image_form!
      node.click_button('Save Image')
      stale!
      window.change_to(ShowPage, NewPage)
    end
  end
end
