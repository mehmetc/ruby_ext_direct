#require 'ext_direct'

class ApiAction < Cramp::Action
  on_start :render_api

  def render_api
#    ExtDirect::Api.expose_all "/Users/mehmetc/Sources/LBT/ext_direct/examples/rack/exposed_classes"
    render ExtDirect::Api.to_json
    finish
  end

  def respond_with
  #  content_type = params[:format] == 'xml' ? 'application/xml' : 'application/json'
    [200, {'Content-Type' => 'application/json'}]
  end


end
