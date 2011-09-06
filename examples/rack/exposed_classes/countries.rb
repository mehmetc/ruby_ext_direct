class Countries
  attr_reader :countries
  def initialize
    @countries =[ {'id' => 1, 'code' => 'be', 'value' => 'Belgium'}, {'id' => 2, 'code' => 'us', 'value' => 'United States'}]
  end
  
  def get
    @countries
  end
end