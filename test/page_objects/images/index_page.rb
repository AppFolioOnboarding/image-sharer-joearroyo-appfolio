module Images
  class IndexPage < AePageObjects::Document
    path :images

    element :add_image, locator: '.image-link'
    collection :images,
               locator: '.image-index',
               item_locator: '.image-container',
               contains: ImageElement

    def add_new_image!
      add_image.node.click
      stale!
      window.change_to(NewPage)
    end

    def delete_first_image
      image = images.first
      image.delete
    end

    def image_on_page?(image_url)
      images.any? do |image|
        image_url == image.url
      end
    end
  end
end
