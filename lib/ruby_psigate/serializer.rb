module RubyPsigate
  class Serializer
    
    def initialize(hash, options = { :header => false })
      raise ArgumentError unless hash.is_a?(Hash)
      @hash = hash
      @header = options[:header]
    end
    
    def to_xml
      @builder = Builder::XmlMarkup.new
      @builder.instruct! if @header

      for key, value in @hash
        case value
        when String
          @builder.send(key.to_sym, value)
        when Hash
          @builder.send(key.to_sym) do
            @builder << Serializer.new(value).to_xml
          end
        when Array
          values = value
          values.each do |val|
            @builder.send(key.to_sym) do
              @builder << Serializer.new(val).to_xml
            end
          end
        else
          raise ArgumentError, "Unknown class: #{value.class}"
        end
      end
      
      @builder.target!
    end
    
  end
end