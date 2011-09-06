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
            
      @exposed_api.store(class_to_expose.name, methods)
    end
    
    def self.expose_all(class_dir)
     
      Dir.glob("#{class_dir}/**/*.rb").each do |r|
        rr = r.split("#{class_dir}/")[1].gsub('.rb','')     
        require "#{class_dir}/#{rr}"
        klass = self.class.const_get(rr.classify)
        self.expose klass
      end      
    end
        
    def self.to_json      
      api = {:url => '/router', 
             :type => 'remoting',
             :actions => @exposed_api}
             
      "REMOTING_API = #{api.to_json};"
    end
  end
end