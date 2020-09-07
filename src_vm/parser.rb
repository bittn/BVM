module BVM
  class Parser
    def initialize(program)
      @program = program.split("\n")
    end

    def parse
      parsed_program = []
      labels = {}
      @program.each_with_index do |line,index|
        line.strip!
        if /\A:([a-z0-9]+)\z/ =~ line
          labels[$1] = index
          parsed_program.push(line)
        elsif /\Aif goto :([a-z0-9]+)\z/ =~ line
          if labels[$1] == nil
            raise "Label error"
          else
            parsed_program.push("if goto #{labels[$1]}:#{$1}")
          end
        else
          parsed_program.push(line)
        end
      end
      return parsed_program
    end
  end
end

if $0 == __FILE__
  program = <<-EOP
:label
test
test
if goto :label
test
test
:label2
test
test
if goto :label2
  EOP

  p BVM::Parser.new(program).parse
end
