class RouterAction < Cramp::Action
  on_start :route_data_to_class

  def route_data_to_class
    ExtDirect::Api.expose_all "/Users/mehmetc/Sources/LBT/ext_direct/examples/rack/exposed_classes"
    data = ''
    if request.post?
      data = request.env['rack.input'].gets
      result = ExtDirect::Router.route(data)
    end
    
    render result.to_json
  end
  
  def respond_with
    [200, {'Content-Type' => 'application/json'}]
  end  
end