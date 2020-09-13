module Bittn
  class Runner
    def initialize(lang)
      @lang = lang
      @bytecode = ByteCode.new()
    end

    def run(tree)
      node = Marshal.load(tree[0])
      result = node.run(@bytecode)
      Marshal.load(@lang.finish).new(nil).run(@bytecode)
      if result == nil
        raise BittnError, "#{node.class.name} is unknown."
      end
      return @bytecode
    end
  end
end
