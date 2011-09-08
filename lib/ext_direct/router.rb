module ExtDirect
  class Router
    def self.route(request)
        result = nil
        params = self.parse_request(request)
        
        if params.is_a? Array
          result = []
          params.each do |p|
            result << self.call_method(p)
          end
        else
          result = self.call_method(params)
        end
        
        result
    end

    private
    def self.call_method(params)      
        data = ''
        #get Class
        klass = self.class.const_get(params[:klass_name])
        #call method on class                
        klass_instance = klass.new
        method_to_call = klass_instance.method(params[:method_to_call_name].to_sym)

        if method_to_call.parameters.size > 0
          data = method_to_call.call(params[:args])
        else
          data = method_to_call.call
        end

      response = {
        :type   => params[:call_type],
        :tid    => params[:tid],
        :action => params[:klass_name],
        :method => params[:method_to_call_name],
        :result => data
      }      
    rescue Exception => e
      response = {
        :type    => 'exception',
        :message => e.message,
        :where   => e.backtrace.join("\n")
      }
    end
    
    def self.parse_request(request)
      params = nil
      xparams_raw = JSON::parse(request)

      if xparams_raw.is_a? Array
        params = []
        xparams_raw.each do |p|
          params << self.xparams_to_params(p)
        end
      else
        params = self.xparams_to_params(xparams_raw)
      end

      params
    end
    
    def self.xparams_to_params(xparams)
      params = {}
      
      xparams_action = 'action'
      xparams_method = 'method'
      xparams_tid    = 'tid'
      xparams_type   = 'type'

      #determine if transaction is a Form post
      form_transaction = false
      if xparams.include?('extTID')
        form_transaction = true        
        xparams_action   = 'extAction'
        xparams_method   = 'extMethod'
        xparams_tid      = 'extTID'
      end

      params.store(:tid, xparams.delete(xparams_tid))
      params.store(:klass_name, xparams.delete(xparams_action))
      params.store(:method_to_call_name, xparams.delete(xparams_method))
      params.store(:call_type, xparams.delete(xparams_type))
      
      if form_transaction
        params.store(:args, xparams)
      else
        params.store(:args, xparams['data'])
      end      
      
      params      
    end
    
  end
end