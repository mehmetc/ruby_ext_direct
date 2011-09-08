require 'json'

module ExtDirect
  class Api
    #@exposed_api = {}
    attr_reader :exposed_api
    
    def self.expose(class_to_expose, options = {})
      @exposed_api = {} if @exposed_api.nil?
      
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
      @exposed_api = {}
     
      Dir.glob("#{class_dir}/**/*.rb").each do |r|
        rr = r.split("#{class_dir}/")[1].gsub('.rb','')     
        puts "#{class_dir}/#{rr}"
        require "#{class_dir}/#{rr}"
 
        klass = self.class.const_get(rr.split('_').map{|c| c.capitalize}.join(''))
        self.expose klass
      end      
    end
        
    def self.to_json      
      api = self.to_raw
      "REMOTING_API = #{api.to_json};"
    end
    
    def self.to_raw
      api = {:url => '/router', 
             :type => 'remoting',
             :actions => @exposed_api}      
    end
  end
end