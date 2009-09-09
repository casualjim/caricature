# WARNING : RAKE AUTO-GENERATED FILE.  DO NOT MANUALLY EDIT!
# RUN : 'rake gem:update_gemspec'

Gem::Specification.new do |s|
  s.authors = ["Ivan Porto Carrero"]
  s.bindir = "bin"
  s.add_dependency "uuidtools", ">= 2.0.0, runtime"
  s.description = "Caricature brings simple mocking to Ruby, DLR and CLR."
  s.email = "ivan@flanders.co.nz"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc",
 "Rakefile",
 "caricature.gemspec",
 "lib/caricature.rb",
 "lib/caricature/clr.rb",
 "lib/caricature/clr/aspnet_mvc.rb",
 "lib/caricature/clr/descriptor.rb",
 "lib/caricature/clr/isolation.rb",
 "lib/caricature/clr/isolator.rb",
 "lib/caricature/clr/messenger.rb",
 "lib/caricature/descriptor.rb",
 "lib/caricature/expectation.rb",
 "lib/caricature/isolation.rb",
 "lib/caricature/isolator.rb",
 "lib/caricature/messenger.rb",
 "lib/caricature/method_call_recorder.rb",
 "lib/caricature/verification.rb",
 "lib/caricature/version.rb",
 "lib/core_ext/array.rb",
 "lib/core_ext/class.rb",
 "lib/core_ext/core_ext.rb",
 "lib/core_ext/hash.rb",
 "lib/core_ext/module.rb",
 "lib/core_ext/object.rb",
 "lib/core_ext/string.rb",
 "lib/core_ext/system/string.rb",
 "lib/core_ext/system/type.rb",
 "spec/bacon_helper.rb",
 "spec/bin/ClrModels.dll",
 "spec/bin/ClrModels.dll.mdb",
 "spec/integration/callback_spec.rb",
 "spec/integration/clr_to_clr_spec.rb",
 "spec/integration/clr_to_ruby_spec.rb",
 "spec/integration/indexer_spec.rb",
 "spec/integration/ruby_to_ruby_spec.rb",
 "spec/models/ClrModels.cs",
 "spec/unit/core_ext_spec.rb",
 "spec/unit/descriptor_spec.rb",
 "spec/unit/expectation_spec.rb",
 "spec/unit/interop_spec.rb",
 "spec/unit/isolation_spec.rb",
 "spec/unit/isolator_spec.rb",
 "spec/unit/messaging_spec.rb",
 "spec/unit/method_call_spec.rb",
 "spec/unit/sword_spec.rb",
 "spec/unit/verification_spec.rb"]
  s.has_rdoc = true
  s.homepage = "http://casualjim.github.com/caricature"
  s.loaded = false
  s.name = "caricature"
  s.platform = "ruby"
  s.rdoc_options = ["--quiet", "--title", "Caricature brings simple mocking to Ruby, DLR and CLR.", "--main", "lib/caricature/isolation.rb", "--line-numbers", "--inline-source", "--format", "darkfish"]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 1.8.4"
  s.required_rubygems_version = ">= 0"
  s.rubyforge_project = "caricature"
  s.rubygems_version = "1.3.5"
  s.specification_version = 3
  s.summary = "Caricature brings simple mocking to Ruby, DLR and CLR."
  s.version = "0.7.0"
end