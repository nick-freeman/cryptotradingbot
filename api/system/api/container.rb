require "dry/web/container"
require "dry/system/components"

module Api
  class Container < Dry::Web::Container
    configure do
      config.name = :api
      config.listeners = true
      config.default_namespace = "api"
      config.logger = Dry::Monitor::Logger.new(config.root.join(config.log_dir).join("#{config.name}_#{config.env}.log").realpath)
      config.auto_register = %w[lib/api]
    end

    load_paths! "lib"
  end
end