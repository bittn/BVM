require "rbconfig"

task :default => :install

desc "script of install bittn programming language"

task :install do
  if __dir__ != "#{ENV["HOME"]}/.bittn"
    puts "\e[31mPlease move this folder to ~/.bittn\e[0m"
    exit 1
  end
  if Process.uid != 0
    puts "\e[31mPermission denid\e[0m"
    exit 1
  end
  host_os = RbConfig::CONFIG["host_os"]
  case host_os
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    Rake::Task[":install_windows"].execute(host_os)
  when /darwin|mac os/
    if Gem::Version.create(`sw_vers -productVersion`) >= Gem::Version.create("10.15")
      Rake::Task["install_macos_zsh"].execute()
    else
      Rake::Task["install_macos_bash"].execute()
    end
  when /linux/
    Rake::Task["install_linux"].execute()
  when /solaris|bsd/
    Rake::Task["install_unix"].execute()
  else
    Rake::Task["install_unknown"].execute(host_os)
  end
end

task :install_unknown do |host_os|
  puts "\e[31mNot supported host os(#{host_os})\e[0m"
  exit 1
end

task :install_macos_zsh do
  puts "\e[34mYour OS is supported(macOS Catalina or later)\e[0m"
  sh "cp bin/bittn_zsh /usr/local/bin/bittn"
  sh "cp bin/biter_zsh /usr/local/bin/biter"
  print "\e[32m"
  puts "---- successfully install ----"
  case ENV["SHELL"].split("/").last
  when /bash|zsh/
    puts " # in .bashrc"
    puts "export BITTNDIR=#{`pwd`}"
    puts "export PATH=$PATH:/usr/local/bin"
  when "fish"
    puts " # in .config/fish/config.fish"
    puts "set -x BITTNDIR #{`pwd`}"
    puts "set PATH /usr/local/bin $PATH"
  else
    puts " # in .bashrc"
    puts "set -x BITTNDIR #{`pwd`}"
    puts "set PATH /usr/local/bin $PATH"
  end
  print "\e[0m"
  exit 0
end

task :install_macos_bash do
  puts "\e[34mYour OS is supported(macOS Mojave or earlier)\e[0m"
  sh "cp bin/bittn_bash /usr/local/bin/bittn"
  sh "cp bin/biter_bash /usr/local/bin/biter"
  print "\e[32m"
  puts "---- successfully install ----"
  case ENV["SHELL"].split("/").last
  when /bash|zsh/
    puts " # in .bashrc"
    puts "export BITTNDIR=#{`pwd`}"
    puts "export PATH=$PATH:/usr/local/bin"
  when "fish"
    puts " # in .config/fish/config.fish"
    puts "set -x BITTNDIR #{`pwd`}"
    puts "set PATH /usr/local/bin $PATH"
  else
    puts " # in .bashrc"
    puts "set -x BITTNDIR #{`pwd`}"
    puts "set PATH /usr/local/bin $PATH"
  end
  print "\e[0m"
  exit
end

task :install_linux do
  puts "\e[34mYour OS is supported(Linux)\e[0m"
  sh "cp bin/bittn_bash /usr/local/bin/bittn"
  sh "cp bin/biter_bash /usr/local/bin/biter"
  print "\e[32m"
  puts "---- successfully install ----"
  case ENV["SHELL"].split("/").last
  when /bash|zsh/
    puts " # in .bashrc"
    puts "export BITTNDIR=#{`pwd`}"
    puts "export PATH=$PATH:/usr/local/bin"
  when "fish"
    puts " # in .config/fish/config.fish"
    puts "set -x BITTNDIR #{`pwd`}"
    puts "set PATH /usr/local/bin $PATH"
  else
    puts " # in .bashrc"
    puts "set -x BITTNDIR #{`pwd`}"
    puts "set PATH /usr/local/bin $PATH"
  end
  print "\e[0m"
  exit 0
end

task :install_unix do
  puts "\e[34mYour OS is supported(Unix)\e[0m"
  sh "cp bin/bittn_bash /usr/local/bin/bittn"
  sh "cp bin/biter_bash /usr/local/bin/biter"
  print "\e[32m"
  puts "---- successfully install ----"
  case ENV["SHELL"].split("/").last
  when /bash|zsh/
    puts " # in .bashrc"
    puts "export BITTNDIR=#{`pwd`}"
    puts "export PATH=$PATH:/usr/local/bin"
  when "fish"
    puts " # in .config/fish/config.fish"
    puts "set -x BITTNDIR #{`pwd`}"
    puts "set PATH /usr/local/bin $PATH"
  else
    puts " # in .bashrc"
    puts "set -x BITTNDIR #{`pwd`}"
    puts "set PATH /usr/local/bin $PATH"
  end
  print "\e[0m"
  exit 0
end
