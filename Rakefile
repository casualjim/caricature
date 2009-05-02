
desc "The default task is to run all the specs"
task :default => :spec

desc "Runs all the specs"
task :spec do
  system "ibacon #{Dir.glob('spec/**/*_spec.rb').join(' ')}"
end

namespace :spec do 
  
end


