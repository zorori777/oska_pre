require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module OsakanOldLadies
  class Application < Rails::Application
    config.load_defaults 5.1

    config.generators do |g|
      g.test_framework false
      g.helper false
      g.assets false
    end
  end
end
