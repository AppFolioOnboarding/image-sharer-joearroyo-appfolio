module Images
  class ShowPage < AePageObjects::Document
    path :image

    element :image, locator: '#img'
    element :home, locator: '.logo'
    collection :tags, locator: '.js-image-tags', item_locator: '.js-image-tag'

    def url_on_page?(url)
      node.find("img[src=\"#{url}\"]").present?
    end

    def tags_on_page?(tag_list)
      user_tags = tag_list.split(',').map(&:strip)
      page_tags = tags.map { |tag| tag.text.delete('#') }
      user_tags == page_tags
    end

    def go_back_to_index!
      home.node.click
      stale!
      window.change_to(IndexPage)
    end
  end
end
