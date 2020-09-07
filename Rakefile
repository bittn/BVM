require "rbconfig"

# gemfile do
#   source "https://rubygems.org"
#   gem "rbconfig"
# end

task :default => :install

desc "script of install bittn programming language"

task :install do
  host_os = RbConfig::CONFIG["host_os"]
  case host_os
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    Rake::Task[":install_unknown"].execute(host_os)
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
  puts "\e[31mUnknown host os(#{host_os})\e[0m"
  exit 1
end

task :install_macos_zsh do
  puts "\e[34mmacos zsh\e[0m"
  exit 0
end

task :install_macos_bash do
  puts "\e[34mmacos bash\e[0m"
  exit 0
end

task :install_linux do
  puts "\e[34mlinux\e[0m"
  exit 0
end

task :install_unix do
  puts "\e[34munix\e[0m"
  exit 0
end
