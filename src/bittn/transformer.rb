module Bittn
  class Transformer
    def initialize(lang,bikefile)
      @bikefile = bikefile
      require @bikefile
      @lang = lang
      @obj = @lang.obj
      @type = @lang.type
    end
    def transform(tree)
      result = []
      tree.each do |key,value|
        if @obj[key]==nil&&@type[key]==nil
          raise TransformError, "#{key} is not specified in nodes."
        elsif @obj[key]!=nil
          node = Marshal.load(@obj[key])
          data = []
          value.size.times do |n|
            if tree[key].is_a?(Hash)
              data[n] = transform(tree[key])
            else
              data[n] = transform(tree[key.intern][n])
            end
          end
          result.push(Marshal.dump(node.new(data)))
        elsif @type[key]!=nil
          node = Marshal.load(@type[key])
          result.push(Marshal.dump(node.new(value)))
        end
      end
      return result
    end
  end
end
