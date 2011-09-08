require "rubygems"
require "bundler"

module API
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    def self.routes
      @_routes ||= eval(File.read('./config/routes.rb'))
    end

    def self.database_config
      @_database_config ||= YAML.load(File.read('./config/database.yml')).with_indifferent_access
    end

    # Initialize the application
    def self.initialize!
      ActiveRecord::Base.configurations = API::Application.database_config
      ActiveRecord::Base.establish_connection(API::Application.env)
      ExtDirect::Api.expose_all "/Users/mehmetc/Sources/LBT/ext_direct/examples/rack/exposed_classes"
    end

  end
end

Bundler.require(:default, API::Application.env)

# Preload application classes
Dir['./app/**/*.rb'].each {|f| require f}
