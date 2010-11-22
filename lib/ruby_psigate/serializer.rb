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
      # build_level(@hash)
      # @builder.target!
      
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
    
    private
    
    # def build_level(hash_level)
    #   for key, value in hash_level
    #     tag = key
    #     if value.is_a? Array
    #       build_level_from_array_element(tag, value)
    #     else
    #       @builder.tag!(tag) { @builder}
    #     end
    #   end
    # end
    # 
    # def build_level_from_array_element(tag, array_elements)
    #   array_elements.each do |element|
    #     @builder.tag!(tag) {
    #       element.each_pair do |key, value|
    #         @builder.tag!(key) { |level| value.is_a?(Hash) ? build_level(value) : level.text!(value) }
    #       end
    #     }
    #   end
    # end
    
  end
end