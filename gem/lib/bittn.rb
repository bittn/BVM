require "bittn/version"
require 'parslet'

module Bittn
  class BaseParser < Parslet::Parser
  end

  class Version < Gem::Version
  end

  class BaseLang
    attr_reader :name,:version,:kinds
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
    def obj
      return @obj.map do |key,value|
        return [key,Marshal.dump(value)]
      end.to_h
    end
    def type
      return @type.map do |key,value|
        return [key,Marshal.dump(value)]
      end.to_h
    end
  end
end
