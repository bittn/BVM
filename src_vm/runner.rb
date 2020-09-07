module BVM
  def Runner
    def initialize(parsed_program)
      @prgoram = parsed_program
      @stack = []
    end

    def run
      @program.each_with_index do |line,index|
        line = line.split(" ")
        op = line[1]
        case op
        when :push
          @stack.push(line[1])
        when :pop
          @stack.pop
        when :dup
          temp = @stack.pop
          @stack.push(temp)
          @stack.push(temp)
        when :add
          @stack.push(@stack.pop.to_i+@stack.pop.to_i)
        when :sub
          @stack.push(@stack.pop.to_i-@stack.pop.to_i)
        when :mul
          @stack.push(@stack.pop.to_i*@stack.pop.to_i)
        when :div
          @stack.push(@stack.pop.to_i/@stack.pop.to_i)
        when :not
        end
      end
    end
  end
end
