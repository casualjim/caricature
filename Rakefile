require 'rubygems'
require 'ftools'
require 'rake/rdoctask'
require 'rake/rdoctask'
require 'jeweler'

desc "The default task is to run all the specs"
task :default => [:clr_models, :spec]

desc "Runs all the specs"
task :spec do
  system "ibacon #{Dir.glob('spec/**/*_spec.rb').join(' ')}"
end

#desc "Copy binaries"
#task :copy_binaries do
#  File.copy(File.dirname(__FILE__) + "/vendor/moq/Moq.dll", File.dirname(__FILE__) + "/lib/bin/")
#  File.copy(File.dirname(__FILE__) + "/vendor/moq/Moq.pdb", File.dirname(__FILE__) + "/lib/bin/")
#end

namespace :spec do 
  
end

def csc
  system "gmcs"
  $?.pid.zero? ? "csc" : "gmcs"
end

desc "Compiles the clr models"
task :clr_models do
  Dir.chdir(File.dirname(__FILE__))
  files = Dir.glob("spec/models/*.cs").collect { |f| f.gsub(/\//, "\\")  }.join(" ")
  system "#{csc} /noconfig /target:library /debug+ /debug:full /out:spec\\bin\\ClrModels.dll #{files}"
end

begin

  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "caricature"
    gemspec.summary = "Caricature - Bringing simple mocking to the DLR"
    gemspec.email = "ivan@flanders.co.nz"
    gemspec.homepage = "http://github.com/casualjim/caricature"
    gemspec.description = "Caricature - Bringing simple mocking to the DLR"
    gemspec.authors = ["Ivan Porto Carrero"]
    gemspec.rubyforge_project = 'caricature' # This line would be new
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do

    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/caricature/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end

