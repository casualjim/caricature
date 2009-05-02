require 'ftools'

desc "The default task is to run all the specs"
task :default => :spec

desc "Runs all the specs"
task :spec => :copy_binaries do
  system "ibacon #{Dir.glob('spec/**/*_spec.rb').join(' ')}"
end

desc "Copy binaries"
task :copy_binaries do
  File.copy(File.dirname(__FILE__) + "/vendor/moq/Moq.dll", File.dirname(__FILE__) + "/lib/bin/")
  File.copy(File.dirname(__FILE__) + "/vendor/moq/Moq.pdb", File.dirname(__FILE__) + "/lib/bin/")  
end

namespace :spec do 
  
end


