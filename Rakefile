require 'rubygems'
require 'fileutils'
require 'rake/rdoctask'

desc "The default task is to run all the specs"
task :default => [:clr_models, :spec]

desc "Runs all the specs"
task :spec do
  system "ibacon #{Dir.glob('spec/**/*_spec.rb').join(' ')}"
end

namespace :spec do 

  desc "runs the specifications for the different classes"
  task :unit do
    specs = Dir.glob('spec/unit/**/*_spec.rb')
    system "ibacon #{specs.join(' ')}"
  end

  desc "runs the integration tests"
  task :integration do
    specs = Dir.glob('spec/integration/**/*_spec.rb')
    system "ibacon #{specs.join(' ')}"
  end
end

def csc
  system "gmcs"
  $?.pid.zero? ? "csc" : "gmcs"
end

desc "Compiles the clr models"
task :clr_models do
  Dir.chdir(File.dirname(__FILE__))
  files = Dir.glob("spec/models/*.cs").join(' ') #.collect { |f| f.gsub(/\//, "\\")  }.join(" ")
  system "#{csc} /noconfig /target:library /debug+ /debug:full /out:spec/bin/ClrModels.dll #{files}"
end


file_list = Dir.glob("lib/**/*.rb")

desc "Create RDoc documentation"
file 'doc/index.html' => file_list do
  puts "######## Creating RDoc documentation"
  system "rdoc --title 'Caricature isolation framework documentation' -m README README.markdown lib/"
end

desc "An alias for creating the RDoc documentation"
task :rdoc do
  Rake::Task['doc/index.html'].invoke
end

# begin
# 
#   Jeweler::Tasks.new do |gemspec|
#     gemspec.name = "caricature"
#     gemspec.summary = "Caricature - Bringing simple mocking to the DLR"
#     gemspec.email = "ivan@flanders.co.nz"
#     gemspec.homepage = "http://github.com/casualjim/caricature"
#     gemspec.description = "This project aims to make interop between IronRuby objects and .NET objects easier. The idea is that it integrates nicely with bacon and later rspec and that it transparently lets you mock ironruby ojbects as well as CLR objects/interfaces. Caricature handles interfaces, interface inheritance, CLR objects, CLR object instances, Ruby classes and instances of Ruby classes."
#     gemspec.authors = ["Ivan Porto Carrero"]
#     gemspec.rubyforge_project = 'caricature' # This line would be new
#   end
# rescue LoadError
#   puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
# end
# 
# begin
#   require 'rake/contrib/sshpublisher'
#   namespace :rubyforge do
# 
#     desc "Release gem and RDoc documentation to RubyForge"
#     task :release => ["rubyforge:release:gem", 'rubyforge:release:docs']
# 
#     namespace :release do
#       desc "Publish RDoc to RubyForge."
#       task :docs => [:rdoc] do
#         config = YAML.load(
#             File.read(File.expand_path('~/.rubyforge/user-config.yml'))
#         )
# 
#         host = "#{config['username']}@rubyforge.org"
#         remote_dir = "/var/www/gforge-projects/caricature/"
#         local_dir = 'doc'
# 
#         Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
#       end
#     end
#   end
# rescue LoadError
#   puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
# end
# 
#                                  