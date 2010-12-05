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
          @builder.tag!(key.to_sym, value)
        when Hash
          @builder.tag!(key.to_sym) do
            @builder << Serializer.new(value).to_xml
          end
        when Array
          values = value
          values.each do |val|
            @builder.tag!(key.to_sym) do
              @builder << Serializer.new(val).to_xml
            end
          end
        when NilClass
          # do nothing
        else
          raise ArgumentError, "Unknown class: #{value.class}"
        end
      end
      
      @builder.target!
    end
    
  end
end