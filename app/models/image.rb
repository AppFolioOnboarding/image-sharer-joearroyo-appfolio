class Image < ApplicationRecord
  validates :url, presence: true, 
            format: { with: /.+\.(png|jpg|gif|tiff)\Z/i, message: "Invalid image extension" }
  validate :url_must_be_formatted_properly

  def url_must_be_formatted_properly
    error_label = :invalid_url_format
    error_msg = "Invalid url format"
    begin
      uri = URI.parse(url)
      if !uri.is_a?(URI::HTTP) || uri.host.nil?
        errors.add(:url, error_label, message: error_msg)
      end
    rescue URI::InvalidURIError #we don't want an exception to be thrown, only for validation to fail
      errors.add(:url, error_label, message: error_msg)
    end
  end

end
