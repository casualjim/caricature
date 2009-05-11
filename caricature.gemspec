# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{caricature}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ivan Porto Carrero"]
  s.date = %q{2009-05-10}
  s.description = %q{Caricature - Bringing simple mocking to the DLR}
  s.email = %q{ivan@flanders.co.nz}
  s.extra_rdoc_files = [
    "README",
     "README.markdown"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/casualjim/caricature}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{caricature}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Caricature - Bringing simple mocking to the DLR}
  s.test_files = [
    "spec/bacon_helper.rb",
     "spec/core_ext_spec.rb",
     "spec/expectation_spec.rb",
     "spec/interop_spec.rb",
     "spec/isolation_spec.rb",
     "spec/method_call_spec.rb",
     "spec/proxy_spec.rb",
     "spec/verification_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
