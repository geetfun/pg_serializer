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
    
    def test_creates_complicated_markup
      expectation = "<Order><StoreID>teststore</StoreID><Passphrase>test1234</Passphrase><Subtotal>10.00</Subtotal><PaymentType>CC</PaymentType><CardAction>0</CardAction><CardNumber>4111111111111111</CardNumber><CardExpMonth>02</CardExpMonth><CardExpYear>15</CardExpYear><CardIDNumber>3422</CardIDNumber></Order>"
      hash = { 
        :Order => {
          :StoreID        => "teststore",
          :Passphrase     => "test1234",
          :Subtotal       => "10.00",
          :PaymentType    => "CC",
          :CardAction     => "0",
          :CardNumber     => "4111111111111111",
          :CardExpMonth   => "02",
          :CardExpYear    => "15",
          :CardIDNumber   => "3422"
        }
      }
      @result = Serializer.new(hash)
      assert_equal expectation, @result.to_xml
    end
    
    def test_creates_markup_from_array_of_hash_under_same_parent_element
      expectation = "<Item><Name>Mercedes Benz</Name><Price>30000.00</Price></Item><Item><Name>BMW</Name><Price>25000.00</Price></Item>"
      hash = {
        :Item => [
          { :Name => "Mercedes Benz", :Price => "30000.00"},
          { :Name => "BMW", :Price => "25000.00" }
        ]
      }
      
      @result = Serializer.new(hash)
      assert_equal expectation, @result.to_xml
    end
    
    def test_create_markup_from_an_array_of_hash_with_each_array_element_having_its_own_embedded_options
      expectation = "<Item><Name>Mercedes Benz</Name><Price>30000.00</Price><Option><model>sports</model><color>black</color></Option></Item><Item><Name>BMW</Name><Price>25000.00</Price><Option><model>luxury</model><color>red</color></Option></Item>"
      hash = {
        :Item => [
          { :Name => "Mercedes Benz", :Price => "30000.00", :Option => { :model => "sports", :color => "black" } },
          { :Name => "BMW", :Price => "25000.00", :Option => { :model => "luxury", :color => "red" } }
        ]
      }

      @result = Serializer.new(hash)
      assert_equal expectation, @result.to_xml
    end
  
    def test_create_complicated_markup
      expectation = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Request><CID>1000001</CID><UserID>teststore</UserID><Password>testpass</Password><Action>AMA01</Action><Account><Name>Home Simpson</Name><Address1>1234 Evergrove Drive</Address1><City>Toronto</City><Province>ON</Province><Postalcode>M2N3A3</Postalcode><Country>CA</Country><Phone>416-111-1111</Phone><Email>homer@simpsons.com</Email><CardInfo><CardHolder>Homer Simpsons</CardHolder><CardNumber>4111111111111111</CardNumber><CardExpMonth>03</CardExpMonth><CardExpYear>20</CardExpYear></CardInfo></Account></Request>"
      hash = {:Request=>{:CID=>"1000001", :UserID=>"teststore", :Password=>"testpass", :Action=>"AMA01", :Account=>{:Name=>"Home Simpson", :Address1=>"1234 Evergrove Drive", :City=>"Toronto", :Province=>"ON", :Postalcode=>"M2N3A3", :Country=>"CA", :Phone=>"416-111-1111", :Email=>"homer@simpsons.com", :CardInfo=>{:CardHolder=>"Homer Simpsons", :CardNumber=>"4111111111111111", :CardExpMonth=>"03", :CardExpYear=>"20"}}}}
      @result = Serializer.new(hash, :header => true)
      assert_equal expectation, @result.to_xml
    end
    
    def test_nil
      expectation = "<Item><Name>Mercedes Benz</Name><Price>25000.00</Price></Item><Item><Name>BMW</Name></Item>"
      hash = {
        :Item => [
          { :Name => "Mercedes Benz", :Price => "25000.00" },
          { :Name => "BMW", :Price => nil }
        ]
      }
      
      @result = Serializer.new(hash)
      assert_equal expectation, @result.to_xml
    end
  
  end
end