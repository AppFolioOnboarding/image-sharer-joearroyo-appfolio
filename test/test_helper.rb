ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ErrorHelper
  # Finds out whether an error exists on this model object that is specific to a given validation name
  # Rather than testing whether an attribute is simply valid, this can test whether an attribute is
  # valid in the context of a specfic validation test.

  # Is there a better way to do this in ruby?
  # There is a rails function on errors called 'added?' but it only works for _some_ validations
  # It fails to succeed when testing for a format validation because the format detail contains two entries in its hash, unlike the others
  def self.has_error_for_validation(model, attribute, validation_error)
    model.errors.details[attribute].any? { |detail| detail[:error] == validation_error }
  end
end
