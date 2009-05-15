require 'rubygems'
require 'ftools'
require 'rake/rdoctask'
require 'jeweler'

desc "The default task is to run all the specs"
task :default => [:clr_models, :spec]

desc "Runs all the specs"
task :spec do
  system "ibacon #{Dir.glob('spec/**/*_spec.rb').join(' ')}"
end

namespace :spec do 

  desc "runs the specifications for the different classes"
  task :unit do
    specs = Dir.glob('spec/**/*_spec.rb').reject { |file| File..basename(file) == "integration_spec.rb"  }
    system "ibacon #{specs.join(' ')}"
  end

  desc "runs the integration tests"
  task :integration do
    system "ibacon spec/integration_spec.rb"
  end
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
    task :release => ["rubyforge:release:gem"]

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

