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
 "lib/caricature/bacon.rb",
 "lib/caricature/bacon/integration.rb",
 "lib/caricature/clr.rb",
 "lib/caricature/clr/aspnet_mvc.rb",
 "lib/caricature/clr/descriptor.rb",
 "lib/caricature/clr/event_verification.rb",
 "lib/caricature/clr/expectation.rb",
 "lib/caricature/clr/isolation.rb",
 "lib/caricature/clr/isolator.rb",
 "lib/caricature/clr/messenger.rb",
 "lib/caricature/clr/method_call_recorder.rb",
 "lib/caricature/core_ext.rb",
 "lib/caricature/core_ext/array.rb",
 "lib/caricature/core_ext/class.rb",
 "lib/caricature/core_ext/hash.rb",
 "lib/caricature/core_ext/module.rb",
 "lib/caricature/core_ext/object.rb",
 "lib/caricature/core_ext/string.rb",
 "lib/caricature/core_ext/system/string.rb",
 "lib/caricature/core_ext/system/type.rb",
 "lib/caricature/descriptor.rb",
 "lib/caricature/expectation.rb",
 "lib/caricature/isolation.rb",
 "lib/caricature/isolator.rb",
 "lib/caricature/messenger.rb",
 "lib/caricature/method_call_recorder.rb",
 "lib/caricature/rspec.rb",
 "lib/caricature/rspec/integration.rb",
 "lib/caricature/verification.rb",
 "lib/caricature/version.rb",
 "spec/bacon/integration/callback_spec.rb",
 "spec/bacon/integration/clr_to_clr_spec.rb",
 "spec/bacon/integration/clr_to_ruby_spec.rb",
 "spec/bacon/integration/event_spec.rb",
 "spec/bacon/integration/indexer_spec.rb",
 "spec/bacon/integration/ruby_to_ruby_spec.rb",
 "spec/bacon/spec_helper.rb",
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
 "spec/bin/ClrModels.dll",
 "spec/bin/ClrModels.dll.mdb",
 "spec/fixtures/ExplodingCar.cs",
 "spec/fixtures/ExposedChangedSubscriber.cs",
 "spec/fixtures/ExposingWarrior.cs",
 "spec/fixtures/IExplodingWarrior.cs",
 "spec/fixtures/IExposing.cs",
 "spec/fixtures/IExposingBridge.cs",
 "spec/fixtures/IExposingWarrior.cs",
 "spec/fixtures/IHaveAnIndexer.cs",
 "spec/fixtures/IWarrior.cs",
 "spec/fixtures/IWeapon.cs",
 "spec/fixtures/IndexerCaller.cs",
 "spec/fixtures/IndexerContained.cs",
 "spec/fixtures/MyClassWithAStatic.cs",
 "spec/fixtures/Ninja.cs",
 "spec/fixtures/Samurai.cs",
 "spec/fixtures/StaticCaller.cs",
 "spec/fixtures/Sword.cs",
 "spec/fixtures/SwordWithStatics.cs",
 "spec/fixtures/clr_interaction.rb",
 "spec/fixtures/dagger.rb",
 "spec/fixtures/dagger_with_class_members.rb",
 "spec/fixtures/sheath.rb",
 "spec/fixtures/soldier.rb",
 "spec/fixtures/soldier_with_class_members.rb",
 "spec/fixtures/swift_cleanup_crew.rb",
 "spec/fixtures/with_class_methods.rb",
 "spec/models.notused/ClrModels.cs",
 "spec/models.notused/ruby_models.rb",
 "spec/rspec/integration/callback_spec.rb",
 "spec/rspec/integration/clr_to_clr_spec.rb",
 "spec/rspec/integration/clr_to_ruby_spec.rb",
 "spec/rspec/integration/indexer_spec.rb",
 "spec/rspec/integration/ruby_to_ruby_spec.rb",
 "spec/rspec/spec_helper.rb",
 "spec/rspec/unit/core_ext_spec.rb",
 "spec/rspec/unit/descriptor_spec.rb",
 "spec/rspec/unit/event_spec.rb",
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
  s.rdoc_options = ["--quiet", "--title", "Caricature brings simple mocking to Ruby, DLR and CLR.", "--main", "README.rdoc", "--line-numbers"]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 1.8.6"
  s.required_rubygems_version = ">= 0"
  s.rubyforge_project = "caricature"
  s.rubygems_version = "1.3.5"
  s.specification_version = 3
  s.summary = "Caricature brings simple mocking to Ruby, DLR and CLR."
  s.version = "0.7.6"
end