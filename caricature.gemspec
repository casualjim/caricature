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
 "lib/caricature",
 "lib/caricature.rb",
 "lib/caricature/bacon",
 "lib/caricature/bacon.rb",
 "lib/caricature/bacon/integration.rb",
 "lib/caricature/clr",
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
 "lib/caricature/rspec",
 "lib/caricature/rspec.rb",
 "lib/caricature/rspec/integration.rb",
 "lib/caricature/verification.rb",
 "lib/caricature/version.rb",
 "lib/core_ext",
 "lib/core_ext/array.rb",
 "lib/core_ext/class.rb",
 "lib/core_ext/core_ext.rb",
 "lib/core_ext/hash.rb",
 "lib/core_ext/module.rb",
 "lib/core_ext/object.rb",
 "lib/core_ext/string.rb",
 "lib/core_ext/system",
 "lib/core_ext/system/string.rb",
 "lib/core_ext/system/type.rb",
 "spec/bacon",
 "spec/bacon/integration",
 "spec/bacon/integration/callback_spec.rb",
 "spec/bacon/integration/clr_to_clr_spec.rb",
 "spec/bacon/integration/clr_to_ruby_spec.rb",
 "spec/bacon/integration/indexer_spec.rb",
 "spec/bacon/integration/ruby_to_ruby_spec.rb",
 "spec/bacon/spec_helper.rb",
 "spec/bacon/unit",
 "spec/bacon/unit/core_ext_spec.rb",
 "spec/bacon/unit/descriptor_spec.rb",
 "spec/bacon/unit/expectation_spec.rb",
 "spec/bacon/unit/interop_spec.rb",
 "spec/bacon/unit/isolation_spec.rb",
 "spec/bacon/unit/isolator_spec.rb",
 "spec/bacon/unit/messaging_spec.rb",
 "spec/bacon/unit/method_call_spec.rb",
 "spec/bacon/unit/sword_spec.rb",
 "spec/bacon/unit/verification_spec.rb",
 "spec/bin",
 "spec/bin/ClrModels.dll",
 "spec/bin/ClrModels.dll.mdb",
 "spec/models",
 "spec/models/ClrModels.cs",
 "spec/models/ruby_models.rb",
 "spec/rspec",
 "spec/rspec/integration",
 "spec/rspec/integration/callback_spec.rb",
 "spec/rspec/integration/clr_to_clr_spec.rb",
 "spec/rspec/integration/clr_to_ruby_spec.rb",
 "spec/rspec/integration/indexer_spec.rb",
 "spec/rspec/integration/ruby_to_ruby_spec.rb",
 "spec/rspec/spec_helper.rb",
 "spec/rspec/unit",
 "spec/rspec/unit/core_ext_spec.rb",
 "spec/rspec/unit/descriptor_spec.rb",
 "spec/rspec/unit/expectation_spec.rb",
 "spec/rspec/unit/interop_spec.rb",
 "spec/rspec/unit/isolation_spec.rb",
 "spec/rspec/unit/isolator_spec.rb",
 "spec/rspec/unit/messaging_spec.rb",
 "spec/rspec/unit/method_call_spec.rb",
 "spec/rspec/unit/sword_spec.rb",
 "spec/rspec/unit/verification_spec.rb",
 "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = "http://casualjim.github.com/caricature"
  s.loaded = false
  s.name = "caricature"
  s.platform = "ruby"
  s.rdoc_options = ["--quiet", "--title", "Caricature brings simple mocking to Ruby, DLR and CLR.", "--main", "README.rdoc", "--line-numbers", "--format", "darkfish"]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 1.8.4"
  s.required_rubygems_version = ">= 0"
  s.rubyforge_project = "caricature"
  s.rubygems_version = "1.3.5"
  s.specification_version = 3
  s.summary = "Caricature brings simple mocking to Ruby, DLR and CLR."
  s.version = "0.7.2"
end