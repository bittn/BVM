require "parslet"

class BVMTestLang < Bittn::BaseParser
  idens = ["print"]
  root(:code)
  rule(:space) { str(" ") }
  rule(:spaces) { space.repeat(1) }
  rule(:space?) { spaces.maybe }
  rule(:return_mark) { str("\n") }
  rule(:returns) { return_mark.repeat(1) }
  rule(:return?) { returns.maybe }
  rule(:sprt?) { (return_mark | space).repeat(0) }
  rule(:sprt) { (return_mark | space).repeat(1) }
  rule(:chars) { str("a") | str("b") | str("c") | str("d") | str("e") | str("f") | str("g") | str("h") | str("i") | str("j") | str("k") | str("l") | str("m") | str("n") | str("o") | str("p") | str("q") | str("r") | str("s") | str("t") | str("u") | str("v") | str("w") | str("x") | str("y") | str("z") | str("A") | str("B") | str("C") | str("D") | str("E") | str("F") | str("G") | str("H") | str("I") | str("J") | str("K") | str("L") | str("M") | str("N") | str("O") | str("P") | str("Q") | str("R") | str("S") | str("T") | str("U") | str("V") | str("W") | str("X") | str("Y") | str("Z") | str("0") | str("1") | str("2") | str("3") | str("4") | str("5") | str("6") | str("7") | str("8") | str("9") | str(" ") | str("!") | str("\\\"") | str("#") | str("$") | str("%") | str("&") | str("\\'") | str("(") | str(")") | str("-") | str("^") | str("@") | str("[") | str(";") | str(":") | str("]") | str(",") | str(".") | str("/") | str("\\\\") | str("=") | str("~") | str("|") | str("`") | str("{") | str("+") | str("*") | str("}") | str("<") | str(">") | str("?") | str("_") | str("\\n") | str("\s") | str("\t") }

  rule(:string) {
    str("\"") >> chars.repeat.as(:chars) >> str("\"")
  }

  rule(:integer) {
    match("[0-9]").repeat(1)
  }

  rule(:code) {
    (line.as(:line) | sprt).repeat(0).as(:code)
  }

  rule(:line) {
    func.as(:func) | value.as(:value)
  }

  rule(:func) {
    idens.map { |f| str(f) }.inject(:|).as(:idens) >> param
  }

  rule(:param) {
    str("(") >> sprt? >> (sprt? >> line.as(:param) >> sprt? >> (sprt? >> str(",") >> sprt? >> line.as(:param) >> sprt?).repeat(0)).maybe >> sprt? >> str(")")
  }

  rule(:value) {
    string.as(:string) | integer.as(:integer)
  }
end

class Lang < Bittn::BaseLang
  def initialize
    @name = "BVMTestLang"
    @version = Bittn::Version.create("0.0.0-dev")
    @parser = BVMTestLang
    @finish = Marshal.dump(FinishNode)
    @obj = {
      :code => Marshal.dump(CodeNode),
      :line => Marshal.dump(LineNode),
      :func => Marshal.dump(FuncNode),
      :param => Marshal.dump(ParamNode),
      :value => Marshal.dump(ValueNode),
    }
    @type = {
      :idens => Marshal.dump(IdensNode),
      :string => Marshal.dump(StringNode),
      :integer => Marshal.dump(IntegerNode),
    }
  end
end

class FinishNode < Bittn::BaseNode
  def run(code)
    code.add("ret 0")
  end
end

class CodeNode < Bittn::BaseObject
  def call(code)
    code.add("goto :code#{self.object_id}")
    code.add("ret 0")
    code.add(":code#{self.object_id}")
    @data.each do |hash|
      Marshal.load(hash[0]).run(code)
    end
  end
end

class LineNode < Bittn::BaseObject
  def call(code)
    code.add("goto :line#{self.object_id}")
    code.add("ret 0")
    code.add(":line#{self.object_id}")
    Marshal.load(@data[0][0]).run(code)
  end
end

class FuncNode < Bittn::BaseObject
  def call(code)
    idens = Marshal.load(@data[0][0]).run(code)
    param = Marshal.load(@data[0][1]).run(code)
    code.add("goto :func#{self.object_id}")
    code.add("ret 0")
    code.add(":func#{self.object_id}")
    case idens
    when "print"
      PrintNode.new(param).run(code)
    end
  end
end

class PrintNode < Bittn::BaseObject
  def call(code)
    code.add("goto :print#{self.object_id}")
    code.add("ret 0")
    code.add(":print#{self.object_id}")
    code.add("push #{@data}")
    code.add("push 1")
    code.add("call")
  end
end

class IdensNode < Bittn::BaseType
  def exec(code)
    return @data.to_s
  end
end

class ParamNode < Bittn::BaseObject
  def call(code)
    code.add("goto :param#{self.object_id}")
    code.add("ret 0")
    code.add(":param#{self.object_id}")
    return Marshal.load(@data[0][0]).run(code)
  end
end

class ValueNode < Bittn::BaseObject
  def call(code)
    code.add("goto :value#{self.object_id}")
    code.add("ret 0")
    code.add(":value#{self.object_id}")
    return Marshal.load(@data[0][0]).run(code)
  end
end

class StringNode < Bittn::BaseType
  def exec(code)
    return @data[:chars].to_s
  end
end

class IntegerNode < Bittn::BaseType
  def exec(code)
    return data[0].to_i
  end
end
