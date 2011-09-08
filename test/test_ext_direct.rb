$LOAD_PATH << '../lib'
require 'rubygems'
require 'shoulda'
require 'test/unit'
require 'ext_direct'

class MyClass
  def method_without_arguments
    "method_without_arguments called"
  end

  def method_with_arguments(arg1)
    "method_with_arguments called: #{arg1}"
  end
end



class TestExtDirect < Test::Unit::TestCase
  context 'Test ext_direct gem' do
    setup do
      @request_without_arguments   = "{\"action\":\"MyClass\",\"method\":\"method_without_arguments\",\"data\":null,\"type\":\"rpc\",\"tid\":1}"
      @request_with_arguments      = "{\"action\":\"MyClass\",\"method\":\"method_with_arguments\",\"data\":[42],\"type\":\"rpc\",\"tid\":1}"
      @request_with_form_arguments = "{\"extAction\":\"MyClass\",\"extMethod\":\"method_with_arguments\",\"extTID\":1, \"a\":1,\"b\":2}"
      @request_multiple_actions    = "[{\"action\":\"MyClass\",\"method\":\"method_with_arguments\",\"data\":[{\"id\":1,\"name\":\"Mehmet Celik1\",\"address\":\"Country road 8, Takemehome\",\"country\":\"be\"}],\"type\":\"rpc\",\"tid\":2},{\"action\":\"MyClass\",\"method\":\"method_without_arguments\",\"data\":null,\"type\":\"rpc\",\"tid\":3}]"
    end

    should "parse request without arguments" do
      expected = {:tid=>1,
                  :klass_name=>"MyClass",
                  :method_to_call_name=>"method_without_arguments",
                  :call_type=>"rpc",
                  :args=>nil}

      result = ExtDirect::Router.send(:parse_request, @request_without_arguments)

      assert_equal(expected, result)
    end
    
    should "parse request with arguments" do
      expected = {:tid=>1,
                  :klass_name=>"MyClass",
                  :method_to_call_name=>"method_with_arguments",
                  :call_type=>"rpc",
                  :args=>[42]}
        
      result = ExtDirect::Router.send(:parse_request, @request_with_arguments)

      assert_equal(expected, result)      
    end

    should "parse request with form arguments" do
      expected = {:tid=>1,
                  :klass_name=>"MyClass",
                  :method_to_call_name=>"method_with_arguments",
                  :call_type=>nil, #TODO figure out which type this is!!!
                  :args=>{"a"=>1, "b"=>2}}
      result = ExtDirect::Router.send(:parse_request, @request_with_form_arguments)

      assert_equal(expected, result)            
    end

    should "parse multiple actions" do
      expected = [{:tid=>2,
        :klass_name=>"MyClass",
        :method_to_call_name=>"method_with_arguments",
        :call_type=>"rpc",
        :args=>
         [{"id"=>1,
           "name"=>"Mehmet Celik1",
           "address"=>"Country road 8, Takemehome",
           "country"=>"be"}]},
       {:tid=>3,
        :klass_name=>"MyClass",
        :method_to_call_name=>"method_without_arguments",
        :call_type=>"rpc",
        :args=>nil}]
      result = ExtDirect::Router.send(:parse_request, @request_multiple_actions)

      assert_equal(Array, result.class)
      assert_equal(2, result.size)
      assert_equal(expected, result)
      
    end

    context 'Calling methods' do
      setup do
        ExtDirect::Api.expose MyClass
      end

      should "call method without parameters" do
        expected = "method_without_arguments called"

        result = ExtDirect::Router.route(@request_without_arguments)[:result]

        assert_equal(expected, result)
      end

      should "call method with parameters" do
        expected = 'method_with_arguments called: [42]'
        result = ExtDirect::Router.route(@request_with_arguments)[:result]
        assert_equal(expected, result)
      end

      should "call method with form parameters" do
      end
      
      should "call multiple actions" do
        expected = [{:type=>"rpc",
          :tid=>2,
          :action=>"MyClass",
          :method=>"method_with_arguments",
          :result=>
           "method_with_arguments called: [{\"id\"=>1, \"name\"=>\"Mehmet Celik1\", \"address\"=>\"Country road 8, Takemehome\", \"country\"=>\"be\"}]"},
         {:type=>"rpc",
          :tid=>3,
          :action=>"MyClass",
          :method=>"method_without_arguments",
          :result=>"method_without_arguments called"}]
          
        result = ExtDirect::Router.route(@request_multiple_actions)#[:result]
        assert_equal(expected, result)        
      end
    end
  end
end
