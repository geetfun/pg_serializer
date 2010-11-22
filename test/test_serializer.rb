require 'helper'

module RubyPsigate
  class TestSerializer < Test::Unit::TestCase
  
    def test_raises_error_if_input_is_not_a_hash
      my_array = ["hello", "world"]
      assert_raises ArgumentError do
        Serializer.new(my_array)
      end
    end
  
    def test_creates_basic_markup_from_hash
      expectation = "<Something>Hello World</Something>"
      hash = {:Something => "Hello World"}
      @result = Serializer.new(hash)
      assert_equal expectation, @result.to_xml
    end
  
    def test_creates_one_level_nested_markup_from_hash
      expectation = "<Family><Dad>Bob</Dad><Mom>Jane</Mom></Family>"
      hash = {:Family => {:Dad => "Bob", :Mom => "Jane"}}
      @result = Serializer.new(hash)
      assert_equal expectation, @result.to_xml
    end
    
    def test_creates_two_level_nested_markup_from_hash
      expectation = "<Family><Dad>Bob</Dad><Mom>Jane</Mom><Children><Son>Mike</Son><Daughter>Ann</Daughter></Children></Family>"
      hash = { :Family => { :Dad => "Bob", :Mom => "Jane", :Children => { :Son => "Mike", :Daughter => "Ann" } } }
      @result = Serializer.new(hash)
      assert_equal expectation, @result.to_xml
    end
    
    def test_includes_header
      expectation = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Something>Hello World</Something>"
      hash = { :Something => "Hello World" }
      @result = Serializer.new(hash, :header => true)
      assert_equal expectation, @result.to_xml
    end
  
  end
end