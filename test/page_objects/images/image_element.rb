module Images
  class ImageElement < AePageObjects::Element
    def url
      node.find('img')[:src]
    end

    def delete
      document.node.accept_confirm do
        node.find('.image-delete-btn').click
      end
    end
  end
end
