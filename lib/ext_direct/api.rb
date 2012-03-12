require 'json'

module ExtDirect
# Simply expose a class 
# @author Mehmet Celik
  class Api
    @exposed_api_raw = nil
    @router_url = '/router'
    
# Expose a class
#
# @author Mehmet Celik
# @param [Class] class that needs to be exposed
# @param [Hash] instructions to how to expose the class. For now just the ':only' key is accepted.
# @return [Hash] returns a list of exposed classes
    def self.expose(class_to_expose, options = {})
      @exposed_api_raw = {} if @exposed_api_raw.nil?
      
      methods = []
      
      if options.include?(:only)
        raw_methods = options[:only] || []
      else
        raw_methods = class_to_expose.instance_methods(false) - (options[:except] || [])
        raw_methods += class_to_expose.methods(false) - (options[:except] || [])        
      end
      
      raw_methods.uniq!
      raw_methods.each do |m|
        name = m
#        len = class_to_expose.method(m).parameters.size
        parameters = []
        class_to_expose.method(m).parameters.each do |p|
          parameters << {:name => p[1].to_s, :optional => p[0] == :opt}
        end
        methods << {:name => name, :parameters => parameters}
      end
            
      @exposed_api_raw.store(class_to_expose.name, methods)
    end
    
# Expose all classes in a directory(conviniance method)
#
# @author Mehmet Celik
# @param [String] Directory where all classes are stored
    def self.expose_all(class_dir)
      @exposed_api_raw = {}
     
      Dir.glob("#{class_dir}/**/*.rb").each do |r|
        rr = r.split("#{class_dir}/")[1].gsub('.rb','')     
        puts "#{class_dir}/#{rr}"
        require "#{class_dir}/#{rr}"
 
        klass = self.class.const_get(rr.split('_').map{|c| c.capitalize}.join(''))
        self.expose klass
      end      
    end

# Return all exposed classes as a JSON String
#
# @author Mehmet Celik
# @return [String] exposed classes as JSON String
    def self.to_json      
      api = self.to_raw
      "REMOTING_API = #{api.to_json};"
    end

# Return a Hash of all exposed classes
#
# @author Mehmet Celik
# @return [Hash] exposed classes
    def self.to_raw
      
      api = {:url => @router_url || '/router', 
             :type => 'remoting',
             :actions => self.exposed_api}
    end
# Set the router url

# @author Mehmet Celik   
# @param [String] router url defaults to '/router'
    def self.router_url=(url = '/router')
      @router_url = url
    end
    
    def self.router_url
      @router_url
    end
    
    def self.exposed_api(show_parameters = false)
      result = @exposed_api_raw
      unless show_parameters
        result = {}
        @exposed_api_raw.each do |k,v|
          methods = []
          v.each do |method|
            methods << {:name => method[:name], :len => method[:parameters].size}
          end
          result.store(k,methods)
        end
      end
      
      result
    end
  end
end