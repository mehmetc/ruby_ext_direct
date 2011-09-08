require "ext_direct/version"
require "ext_direct/api"
require "ext_direct/router"

class String
  def classify_it
    self.split('_').map{|c| c.capitalize}.join('')
  end
end

module ExtDirect

end
