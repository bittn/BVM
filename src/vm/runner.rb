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
          puts "pushed #{line[1..].join(" ")}" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "pop"
          popped = @stack.pop
          puts "popped #{popped}" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "dup"
          popped = @stack.pop
          @stack.push(popped)
          @stack.push(popped)
          puts "dup #{popped}" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "add"
          @stack.push(@stack.pop + @stack.pop)
          puts "add" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "sub"
          @stack.push(@stack.pop - @stack.pop)
          puts "sub" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "mul"
          @stack.push(@stack.pop * @stack.pop)
          puts "mul" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "div"
          @stack.push(@stack.pop / @stack.pop)
          puts "div" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "not"
          @stack.push(!@stack.pop)
          puts "not" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "smaller"
          @stack.push(@stack.pop < @stack.pop)
          puts "smaller" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "bigger"
          @stack.push(@stack.pop > @stack.pop)
          puts "bigger" if @options[:debug]
          puts "NOW STACK: #{@stack.get}" if @options[:debug]
        when "call"
          case @stack.pop
          when "1"
            print @stack.pop.gsub("\\n", "\n")
          end
        when "if"
          if @stack.pop
            value = line[2].split(":")[0]
            label = line[2].split(":")[1]
            puts "goto #{label}" if @options[:debug]
            labels[label] = pc
            pc = value.to_i
          end
        when "ret"
          label = line[1].split(":")[0]
          value = line[1].split(":")[1]
          puts "return #{label}" if @options[:debug]
          if label == "main"
            return value
          else
            pc = labels[label]
          end
        when /\A:[0-9a-z]\z/
        when "goto"
          value = line[1].split(":")[0]
          label = line[1].split(":")[1]
          puts "goto #{label}" if @options[:debug]
          labels[label] = pc
          pc = value.to_i
        else
          p line
        end
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
