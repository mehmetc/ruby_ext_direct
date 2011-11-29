This is an attempt to implement **Ext.Direct** (see http://www.sencha.com/products/extjs/extdirect for more info)

I wanted to have a library that did not have to many dependencies. 

The idea is very simple: 
 
>	1.  add an **'api'** and **'router'** endpoint to your backend.  
>	2.  expose your classes. 
 
and you are set

#INSTALL#
	gem install ruby_ext_direct

---

#Example:#
(For more [examples](https://github.com/mehmetc/ruby_ext_direct_examples for more "EXAMPLES") )

##A RACK based example##

###*Gemfile*

	gem 'ruby_ext_direct', :require => 'ext_direct'


###*web_service.rb*

	require 'rubygems'
	require 'bundler/setup'
	require 'rack'
	require 'json'

	require 'ext_direct'
	
	#Expose all classes in a directory
	ExtDirect::Api.expose_all("./exposed_classes")

	#Generate a client-side descriptor
	map '/api' do
	  run Proc.new { |env|
	    [200, {'Content-Type' => 'text/json'}, [ExtDirect::Api.to_json]]
	  }
	end

	#Route request to methods
	map '/router' do
	  run Proc.new { |env|
	    result = ''

	    req = Rack::Request.new(env)
	    if req.post?
	      data = env["rack.input"].gets
	      result = ExtDirect::Router.route(data)
	    end
    
	    [200, {'Content-Type' => 'text/html'}, [result.to_json]]
	  }
	end

TODO: add documentation  
TODO: add rails engine