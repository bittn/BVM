require "#{ENV["BITTNDIR"]}/src/vm/runner.rb"
require "#{ENV["BITTNDIR"]}/src/vm/error.rb"
require 'optionparser'

module BVM
  class BVM
    def initialize()
      parse_option()
      stdin()
      run()
    end

    def parse_option()
      $options = { debug: false}
      opts = OptionParser.new
      opts.on("-d", "--debug", "use debug mode. (default: #{$options[:debug]})") { |v|
        $options[:debug] = true
      }
      opts.program_name = "BVM"
      tags = Array.new
      `cd #{ENV["BITTNDIR"]};git tag`.chomp.split("\n").each do |t|
        tags.push(Gem::Version.create(t.gsub(/[^[\.\d]]/, "")))
      end
      opts.version = tags.max.to_s
      opts.release = "release"
      opts.banner = "Usage: biter [options] [bikefile] [filename]"
      opts.on("-h", "--help", "show help.") { puts opts.help; exit }
      opts.on("-v", "--version", "show version.") { puts opts.ver; exit }
      begin
        @args = opts.parse(ARGV)
      rescue OptionParser::InvalidOption => e
        usage e.message
      end
    end

    def stdin()
      if @args.size < 1
        raise BVMError, "Biterfile not specified. (FileError)"
      end
      if @args.size > 1
        raise BVMError, "Number of arguments is too more. (LoadError)"
      end
      @filename = @args[0]
      if !File.exist?(@filename)
        raise BVMError, "Biterfile is not found. (FileError)"
      end
      if !File.file?(@filename)
        raise BVMError, "Can't assign to keyword. (FileError)"
      end

    end

    def run()
      code = open(@filename, &:read)
      runner = Runner.new(code,$options)
      @result = runner.run()
      print("RETURN : \n") if $options[:debug]
      pp @result if $options[:debug]
      return @result
    end
  end
end
begin
  if $0 == __FILE__
    BVM::BVM.new()
  end
rescue BVM::BVMError => e
  newblock("bittn error") if $options[:debug]
  puts e.message
  exit(1)
rescue => e
  newblock("standard error") if $options[:debug]
  if $options[:dev]
    raise
  else
    puts "--------------------------!error!--------------------------------"
    puts e.message
    puts "Traceback : "
    puts $@
    puts "-----------------------------------------------------------------"
    puts "Giving the -d option may help."
    puts "If that doesn't work, please issue on Github."
    puts "-----------------------------------------------------------------"
    puts "Thank you for your issue."
    puts ""
    Launchy.open("https://github.com/pinenut-programming-language/bittn/issues/new?labels=&title=bug%20report%20from%20command")
    puts "You can issue on github."
    puts "https://github.com/pinenut-programming-language/bittn/issues/new"
  end
  exit(1)
end

