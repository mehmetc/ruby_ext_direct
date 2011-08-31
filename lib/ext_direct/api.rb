require 'json'

module ExtDirect
  class Api
    @exposed_api = {}
    
    def self.expose(class_to_expose, options = {})
      methods = []
      
      if options.include?(:only)
        raw_methods = options[:only] || []
      else
        raw_methods = class_to_expose.instance_methods(false) - (options[:except] || [])
      end
      
      raw_methods.uniq!
      raw_methods.each do |m|
        name = m
        len = class_to_expose.instance_method(m).parameters.size
        methods << {:name => name, :len => len}
      end
            
      @exposed_api = {class_to_expose.name => methods}
    end
    
    def self.to_json      
      api = {:url => '/router', 
             :type => 'remoting',
             :actions => @exposed_api}
             
      "REMOTING_API = #{api.to_json};"
    end    
  end
end            

=begin
REMOTING_API = {"url":"/direct_router",
                "type":"remoting",
                "actions":{"User":[{"name":"create","len":1},
                                   {"name":"update","len":2},
                                   {"name":"update_all","len":2},
                                   {"name":"delete","len":1},
                                   {"name":"delete_all","len":1},
                                   {"name":"exists","len":1},
                                   {"name":"find","len":1},
                                   {"name":"find_every","len":1},
                                   {"name":"first","len":0},
                                   {"name":"last","len":0},
                                   {"name":"all","len":1},
                                   {"name":"count","len":0}]},
                "namespace":"App.models",
                "srv_env":"development"};
                
                
REMOTING_API = {"url":"/router",
                "type":"remoting",
                "actions":{"CountQueries":[{"get":1}]}};                

=end  