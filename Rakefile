require 'rubygems'
require 'fileutils'
require 'rake/rdoctask'

$:.unshift 'lib'
require 'caricature'
 
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

##############################################################################
# OPTIONS
##############################################################################

PKG_NAME      = 'caricature'
PKG_VERSION   = Caricature::VERSION
AUTHORS       = ['Ivan Porto Carrero']
EMAIL         = "ivan@flanders.co.nz"
HOMEPAGE      = "http://casualjim.github.com/caricature"
SUMMARY       = "Caricature brings simple mocking to Ruby, DLR and CLR."

# These are the common rdoc options that are shared between generation of
# rdoc files using BOTH 'rake rdoc' and the installation by users of a
# RubyGem version which builds rdoc's along with its installation.  Any
# rdoc options that are ONLY for developers running 'rake rdoc' should be
# added in the 'Rake::RDocTask' block below.
RDOC_OPTIONS  = [
                "--quiet",
                "--title", SUMMARY,
                "--main", "lib/caricature/isolation.rb",
                "--line-numbers",
                "--inline-source",
                "--format","darkfish"
                ]

# Extra files outside of the lib dir that should be included with the rdocs.
RDOC_FILES    = (%w( README.rdoc)).sort

# The full file list used for rdocs, tarballs, gems, and for generating the xmpp4r.gemspec.
PKG_FILES     = (%w( Rakefile caricature.gemspec ) + RDOC_FILES + Dir["{lib,spec}/**/*"]).sort

# RDOC
#######
Rake::RDocTask.new do |rd|

  # which dir should rdoc files be installed in?
  rd.rdoc_dir = 'rdoc'

  # the full list of files to be included
  rd.rdoc_files.include(RDOC_FILES, "lib/**/*.rb")

  # the full list of options that are common between gem build
  # and 'rake rdoc' build of docs.
  rd.options = RDOC_OPTIONS

  # Devs Only : Uncomment to also document private methods in the rdocs
  # Please don't check this change in to the source repo.
  #rd.options << '--all'

  # Devs Only : Uncomment to generate dot (graphviz) diagrams along with rdocs.
  # This requires that graphiz (dot) be installed as a local binary and on your path.
  # See : http://www.graphviz.org/
  # Please don't check this change in to the source repo as it introduces a binary dependency.
  #rd.options << '--diagram'
  #rd.options << '--fileboxes'

end

desc "Check syntax of all Ruby files."
task :check_syntax do
  `find . -name "*.rb" |xargs -n1 ruby -c |grep -v "Syntax OK"`
  puts "* Done"
end

##############################################################################
# PACKAGING & INSTALLATION
##############################################################################

# What files/dirs should 'rake clean' remove?
#CLEAN.include ["*.gem", "pkg", "rdoc", "coverage"]

begin
  require 'rake/gempackagetask'

  spec = Gem::Specification.new do |s|
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.authors = AUTHORS
    s.email = EMAIL
    s.homepage = HOMEPAGE
    s.rubyforge_project = PKG_NAME
    s.summary = SUMMARY
    s.description = s.summary
    s.platform = Gem::Platform::RUBY
    s.require_path = 'lib'
    s.executables = []
    s.files = PKG_FILES
    s.test_files = []
    s.has_rdoc = true
    s.extra_rdoc_files = RDOC_FILES
    s.rdoc_options = RDOC_OPTIONS
    s.required_ruby_version = ">= 1.8.4"  
    s.add_runtime_dependency(%q<uuidtools>, [">= 2.0.0"])
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.gem_spec = spec
    pkg.need_tar = true
    pkg.need_zip = true
  end

  namespace :gem do

    desc "Run :package and install the .gem locally"
    task :install => [:update_gemspec, :package] do
      sh %{sudo gem install --local pkg/#{PKG_NAME}-#{PKG_VERSION}.gem}
    end

    desc "Like gem:install but without ri or rdocs"
    task :install_fast => [:update_gemspec, :package] do
      sh %{sudo gem install --local pkg/#{PKG_NAME}-#{PKG_VERSION}.gem --no-rdoc --no-ri}
    end

    desc "Run :clean and uninstall the .gem"
    task :uninstall => :clean do
      sh %{sudo gem uninstall #{PKG_NAME}}
    end

    # Thanks to the Merb project for this code.
    desc "Update Github Gemspec"
    task :update_gemspec do
      skip_fields = %w(new_platform original_platform date)

      result = "# WARNING : RAKE AUTO-GENERATED FILE.  DO NOT MANUALLY EDIT!\n"
      result << "# RUN : 'rake gem:update_gemspec'\n\n"
      result << "Gem::Specification.new do |s|\n"
      spec.instance_variables.sort.each do |ivar|
        value = spec.instance_variable_get(ivar)
        name  = ivar.to_s.split("@").last
        next if skip_fields.include?(name) || value.nil? || value == "" || (value.respond_to?(:empty?) && value.empty?)
        if name == "dependencies"
          value.each do |d|
            dep, *ver = d.to_s.split(" ")
            result <<  "  s.add_dependency #{dep.inspect}, #{ver.join(" ").inspect.gsub(/[()]/, "")}\n"
          end
        else
          case value
          when Array
            value =  name != "files" ? value.inspect : value.sort.uniq.inspect.split(",").join(",\n")
          when String, Fixnum, true, false
            value = value.inspect
          else
            value = value.to_s.inspect
          end
          result << "  s.#{name} = #{value}\n"
        end
      end
      result << "end"
      File.open(File.join(File.dirname(__FILE__), "#{spec.name}.gemspec"), "w"){|f| f << result}
    end

  end # namespace :gem

  # also keep the gemspec up to date each time we package a tarball or gem
  task :package => ['gem:update_gemspec']
  task :gem => ['gem:update_gemspec']

rescue LoadError
  puts <<EOF
###
  Packaging Warning : RubyGems is apparently not installed on this
  system and any file add/remove/rename will not
  be auto-updated in the 'caricature.gemspec' when you run any
  package tasks.  All such file changes are recommended
  to be packaged on a system with RubyGems installed
  if you intend to push commits to the Git repo so the
  gemspec will also stay in sync for others.
###
EOF
end

# we are apparently on a system that does not have RubyGems installed.
# Lets try to provide only the basic tarball package tasks as a fallback.
unless defined? Gem
  begin
    require 'rake/packagetask'
    Rake::PackageTask.new(PKG_NAME, PKG_VERSION) do |p|
      p.package_files = PKG_FILES
      p.need_tar = true
      p.need_zip = true
    end
  rescue LoadError
    puts <<EOF
###
  Warning : Unable to require the 'rake/packagetask'. Is Rake installed?
###
EOF
  end
end


# # Generate all the Rake tasks
# # Run 'rake -T' to see list of generated tasks (from gem root directory)
# $hoe = Hoe.spec 'cloudslide' do
#   self.developer 'Ivan Porto Carrero', 'ivan@flanders.co.nz'
#   self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
#   self.rubyforge_name       = self.name # TODO this is default value
#   self.extra_deps         = [['uuidtools','>= 2.0.0'], ['newgem', '>= 1.5.2']]
# end
# 
# require 'newgem/tasks'
# Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]

# file_list = Dir.glob("lib/**/*.rb")

# desc "Create RDoc documentation"
# file 'doc/index.html' => file_list do
#   puts "######## Creating RDoc documentation"
#   system "rdoc --title 'Caricature isolation framework documentation' -m README README.markdown lib/"
# end
# 
# desc "An alias for creating the RDoc documentation"
# task :rdoc do
#   Rake::Task['doc/index.html'].invoke
# end  

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
