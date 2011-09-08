require 'rubygems'
require 'json'
require 'rack'
require 'ext_direct'

require 'pp'

ExtDirect::Api.expose_all("./exposed_classes")

app = Rack::Builder.new do
  use Rack::ShowExceptions
  
  map '/' do
    run Rack::Directory.new('./html')
  end
  
  map '/api' do
    run Proc.new { |env|
      [200, {'Content-Type' => 'text/json'}, [ExtDirect::Api.to_json]]
    }
  end
  
  map '/router' do
    run Proc.new { |env|
      result = ''

      req = Rack::Request.new(env)
      if req.post?
        data = env["rack.input"].gets
        pp data
        result = ExtDirect::Router.route(data)
      end
      
      [200, {'Content-Type' => 'text/html'}, [result.to_json]]
    }
  end
  
end

run app