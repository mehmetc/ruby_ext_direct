require 'json'

module ExtDirect
# Simply expose a class 
# @author Mehmet Celik
  class Api
    attr_reader :exposed_api

# Expose a class
#
# @author Mehmet Celik
# @param [Class] class that needs to be exposed
# @params [Hash] instructions to how to expose the class. For now just the ':only' key is accepted.
# @return [Hash] returns a list of exposed classes
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
    
# Expose all classes in a directory(conviniance method)
#
# @author Mehmet Celik
# @param [String] Directory where all classes are stored
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
      api = {:url => '/router', 
             :type => 'remoting',
             :actions => @exposed_api}      
    end
  end
end