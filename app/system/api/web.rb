require "dry/web/roda/application"
require_relative "container"

module App
  class Web < Dry::Web::Roda::Application
    configure do |config|
      config.container = Container
      config.routes = "web/routes".freeze
    end

    opts[:root] = Pathname(__FILE__).join("../..").realpath.dirname

    use Rack::Session::Cookie, key: "app.session", secret: self["config"].session_secret

    plugin :csrf, raise: true
    plugin :dry_view
    plugin :error_handler
    plugin :flash
    plugin :multi_route

    route do |r|
      # Enable this after writing your first web/routes/ file
      # r.multi_route

      r.root do
        r.view "welcome"
      end
    end

    error do |e|
      self.class[:rack_monitor].instrument(:error, exception: e)
      raise e
    end

    # Request-specific options for dry-view context object
    def view_context_options
      {
        flash:        flash,
        csrf_token:   Rack::Csrf.token(request.env),
        csrf_metatag: Rack::Csrf.metatag(request.env),
        csrf_tag:     Rack::Csrf.tag(request.env),
      }
    end

    load_routes!
  end
end
