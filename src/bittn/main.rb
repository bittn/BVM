require "parslet"
require "optparse"
require "#{ENV["BITTNDIR"]}/src/bittn/error.rb"
require "#{ENV["BITTNDIR"]}/src/bittn/runner.rb"
require "#{ENV["BITTNDIR"]}/src/bittn/transformer.rb"
require "#{ENV["BITTNDIR"]}/src/bittn/bytecode_transformer.rb"


module Bittn
  class Bittn
    def initialize()
      parse_option()
      parse_script()
      transform_script()
      run_script()
      transform_bytecode()
      save_bytecode()
    end

    def parse_option
      $options = {debug: false}
      @parser_option = OptionParser.new
      @parser_option.on("-d","--debug","run in debug mode") do
        $options[:debug] = true
      end
      @parser_option.program_name = "bittn"
      tags = Array.new
      `cd #{ENV["BITTNDIR"]};git tag`.chomp.split("\n").each do |t|
        tags.push(Gem::Version.create(t.gsub(/[^[\.\d]]/, "")))
      end
      @parser_option.version = tags.max.to_s
      @parser_option.release = "release"
      @parser_option.banner = "Usage: bittn [options] [bikefile] [filename]"
      @parser_option.on("-h", "--help", "show help.") { puts opts.help; exit }
      @parser_option.on("-v", "--version", "show version.") { puts opts.ver; exit }
      begin
        @args = @parser_option.parse(ARGV)
      rescue OptionParser::InvalidOption => e
        usage e.message
      end
      if @args[0]==nil
        raise LoadError, "Bikefile is not specified."
      elsif @args[1]==nil
        raise LoadError, "Script is not specified."
      elsif @args.size > 2
        raise LoadError, "Number of arguments is too more."
      end

      @bikefile = "#{ENV["BITTN_WORKSPACE"]}/#{@args[0]}"
      @scriptfile = @args[1]

      puts "bikefile: #{@bikefile}\nscriptfile: #{@scriptfile}" if $options[:debug]

      if !File.exist?(@scriptfile)
        raise LoadError, "Scriptfile is not found."
      end
      if !File.file?(@scriptfile)
        raise LoadError, "Scriptfile must be file."
      end
      if !File.exist?(@bikefile)
        raise LoadError, "Bikefile is not found."
      end
      if !File.file?(@bikefile)
        raise LoadError, "Can't assign to keyword."
      end
      return @bikefile
    end

    def parse_script()
      require(@bikefile)
      @lang = Lang.new
      @parser_script = Marshal.load(@lang.parser)
      code = open(@scriptfile, &:read)
      @parsed_tree = @parser_script.parse(code)
      puts "PARSE RESULT:" if $options[:debug]
      pp @parsed_tree if $options[:debug]
    end

    def transform_script()
      @transformer_script = Transformer.new(@lang,@bikefile)
      @transformed_tree = @transformer_script.transform(@parsed_tree)
    end

    def run_script()
      @runner_script = Runner.new(@lang)
      @bytecode = @runner_script.run(@transformed_tree)
    end

    def transform_bytecode()
      @transformer_bytecode = BVM::Transformer.new
      @transformed_bytecode = @transformer_bytecode.transform(@bytecode)
    end

    def save_bytecode()
      basename = File.basename(@bikefile.gsub("\/","\\"), ".*").gsub("\\","\/")
      File.write("#{basename}.biter", @transformed_bytecode.get.join("\n"))
      puts "successfully in #{basename}.biter"
    end
  end
end
begin
  if $0 == __FILE__
    Bittn::Bittn.new()
  end
rescue Bittn::LoadError,TransformError => e
  puts "#{e.message} (#{e.class})"
  puts $@ if $options[:debug]
  exit(1)
rescue Parslet::ParseFailed => e
  puts e.message + " (ParseError)"
  exit(1)
rescue => e
  if $options[:debug]
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
    if yesno("Will you issue on github?")
      puts "Thank you for your issue."
      puts ""
      Launchy.open("https://github.com/pinenut-programming-language/bittn/issues/new?labels=&title=bug%20report%20from%20command")
    else
      puts "You can issue on github."
      puts "https://github.com/pinenut-programming-language/bittn/issues/new"
    end
  end
  exit(1)
end

