module BVM
  class Runner
    def initialize(program, options)
      @program = program.split("\n")
      @stack = Stack.new
      @options = options
    end

    def run
      pc = 0
      pp @program if @options[:debug]
      labels = {}
      loop do
        line = @program[pc].split(" ")
        if line == nil
          return 0
        end
        op = line[0]
        puts "OP:#{op} #{line}" if @options[:debug]
        case op
        when "push"
          @stack.push(line[1..].join(" "))
        when "pop"
          @stack.pop
        when "dup"
          popped = @stack.pop
          @stack.push(popped)
          @stack.push(popped)
        when "add"
          @stack.push(@stack.pop + @stack.pop)
        when "sub"
          @stack.push(@stack.pop - @stack.pop)
        when "mul"
          @stack.push(@stack.pop * @stack.pop)
        when "div"
          @stack.push(@stack.pop / @stack.pop)
        when "not"
          @stack.push(!@stack.pop)
        when "smaller"
          @stack.push(@stack.pop < @stack.pop)
        when "bigger"
          @stack.push(@stack.pop > @stack.pop)
        when "call"
          case @stack.pop
          when "1"
            print @stack.pop.gsub("\\n", "\n")
          end
        when "if"
          if @stack.pop
            value = line[2].split(":")[0]
            label = line[2].split(":")[1]
            labels[label] = pc
            pc = value.to_i
          end
        when "ret"
          label = line[1].split(":")[0]
          value = line[1].split(":")[1]
          if label == "main"
            return value
          else
            pc = labels[label]
          end
        when /\A:[0-9a-z]\z/
        when "goto"
          value = line[1].split(":")[0]
          label = line[1].split(":")[1]
          labels[label] = pc
          pc = value.to_i
        else
          p line
        end
        puts "#{pc} stack" if @options[:debug]
        p @stack.get if @options[:debug]
        pc += 1
      end
    end
  end

  class Stack
    def initialize(default = [])
      @stack = default
    end

    def pop
      @stack.pop
    end

    def push(i)
      @stack.push(i)
    end

    def get()
      return @stack
    end
  end
end
