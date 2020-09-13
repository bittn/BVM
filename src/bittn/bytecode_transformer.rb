require "bittn"
module BVM
  class Transformer
    def initialize()
    end

    def transform(bytecode)
      bytecode = bytecode.get
      transformed_bytecode = Bittn::ByteCode.new
      labels = {}
      nlabels = [:main]
      bytecode.each_with_index do |line,index|
        line.strip!
        if /\A:([a-z0-9]+)\z/ =~ line
          labels[$1] = index
          nlabels.push($1)
          transformed_bytecode.add(line)
        elsif /\Aret (.+)\z/ =~ line
          if nlabels==[]
            raise "Label error"
          end
          transformed_bytecode.add("ret #{nlabels.pop}:#{$1}")
        else
          transformed_bytecode.add(line)
        end
      end
      transformed_bytecode = transform_goto(transformed_bytecode,labels)
      return transformed_bytecode
    end

    def transform_goto(bytecode,labels)
      bytecode = bytecode.get
      transformed_bytecode = Bittn::ByteCode.new
      bytecode.each_with_index do |line,index|
        if /\A(if goto|goto) :([a-z0-9]+)\z/ =~ line
          transformed_bytecode.add("#{$1} #{labels[$2]}:#{$2}")
        else
          transformed_bytecode.add(line)
        end
      end
      return transformed_bytecode
    end
  end
end

