require 'rubygems'
require 'yaml'

require 'pp'
class Names
  def load
    names ||= init
    {'total' => names.size, 'data' => names}
  end

  def create(data)
    highest_id = 0
    names ||= init
    
    names.each do |n|
      highest_id = n['id'].to_i if n['id'].to_i == 0 || n['id'].to_i > highest_id
    end

    data.each do |d|
      d['id'] = highest_id + 1      
    end

    names += data

    store(names)

    {'success' => true, 'data' => data, 'message' => 'saved'}
  end


  def update(data)    
    names ||= init
    new_names = []
    highest_id = 0
    
    
    data.each do |d|
      updated = false
      new_names = names.map do |n|
        highest_id = n['id'] if n['id'].to_i == 0 || n['id'].to_i < highest_id
        if n['id'].eql?(d['id'])
          updated = true
          d
        else
          n
        end
      end
      
      unless updated
        data['id'] = highest_id += 1
        new_names += data
      end
      names = new_names
    end
    
    store(new_names)

    {'success' => true, 'data' => data, 'message' => 'updated'}
  end

  private
  def init
    names = []
    if File.exists?('data.yml')
      names = YAML::load_file('data.yml')
    else
      names = [
        {'id' => 1, 'country' => 'be', 'name' =>  'Mehmet Celik', 'address' => 'Country road 8, Takemehome'},
        {'id' => 2, 'country' => 'be', 'name' =>  'Kris Wellens', 'address' => 'Country road 88, Takemehome'}
      ]
      store(names)
    end

    names
  end

  def store(names)
    File.open('data.yml', 'w') do |f|
      f.puts YAML::dump(names)
    end
  end
end
