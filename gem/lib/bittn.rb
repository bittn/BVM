require "bittn/version"
require "parslet"

module Bittn
  class BaseParser < Parslet::Parser
  end

  class Version < Gem::Version
  end

  class BaseLang
    attr_reader :name, :version, :kinds, :obj, :type, :finish

    def initialize
      @name = nil
      @version = nil
      @parser = nil
      @kinds = nil
      @obj = nil
      @type = nil
    end

    def parser
      return Marshal.dump(@parser.new)
    end

    #def obj
    #  return @obj.map do |key,value|
    #    return [key,Marshal.dump(value)]
    #  end.to_h
    #end
    #def type
    #  return @type.map do |key,value|
    #    return [key,Marshal.dump(value)]
    #  end.to_h
    #end
  end

  class BaseNode
    def initialize(data)
      @data = data
      @code = nil
    end

    def call()
      return nil
    end

    def exec()
      return nil
    end

    def run()
      return nil
    end
  end

  class BaseObject < BaseNode
    def run(code)
      call(code)
    end
  end

  class BaseType < BaseNode
    def run(code)
      exec(code)
    end
  end

  class ByteCode
    def initialize()
      @codes = []
    end

    def add(line)
      line.split("\n").map do |p|
        @codes.push(p)
      end
    end

    def get()
      return @codes
    end
  end
end
