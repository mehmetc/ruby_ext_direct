require 'rubygems'

class Names  
  attr_reader :names
  
  def initialize
    @names = [
      {'country' => 'be', 'name' =>  'Mehmet Celik', 'address' => 'Country road 8, Takemehome'},
      {'country' => 'be', 'name' =>  'Kris Wellens', 'address' => 'Country road 88, Takemehome'}
    ]        
  end
  
  def get
    @names
  end
  
  def set(data)
    @names << data
  end
  
end