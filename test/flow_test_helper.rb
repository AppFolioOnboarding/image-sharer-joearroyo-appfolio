require 'test_helper'

require 'active_support/test_case'
require 'capybara/rails'
require 'capybara/dsl'
require 'ae_page_objects'
require 'ae_page_objects/rails'

Dir[File.dirname(__FILE__) + '/page_objects/**/*.rb'].each { |file| require file }

class FlowTestCase < ActiveSupport::TestCase
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  fixtures :all
end

# Tip 3 from http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
module ActiveRecord
  class Base
    mattr_accessor :shared_connection
    self.shared_connection = nil

    def self.connection
      shared_connection || retrieve_connection
    end
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

Capybara.default_driver = Capybara.javascript_driver
