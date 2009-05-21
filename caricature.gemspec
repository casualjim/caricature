# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{caricature}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ivan Porto Carrero"]
  s.date = %q{2009-05-21}
  s.description = %q{This project aims to make interop between IronRuby objects and .NET objects easier. The idea is that it integrates nicely with bacon and later rspec and that it transparently lets you mock ironruby ojbects as well as CLR objects/interfaces. Caricature handles interfaces, interface inheritance, CLR objects, CLR object instances, Ruby classes and instances of Ruby classes.}
  s.email = %q{ivan@flanders.co.nz}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "caricature.gemspec",
     "doc/Array.html",
     "doc/Caricature.html",
     "doc/Caricature/ArgumentRecording.html",
     "doc/Caricature/ClrClassDescriptor.html",
     "doc/Caricature/ClrClassMessenger.html",
     "doc/Caricature/ClrInterfaceDescriptor.html",
     "doc/Caricature/ClrInterfaceIsolator.html",
     "doc/Caricature/ClrInterfaceMessenger.html",
     "doc/Caricature/ClrIsolator.html",
     "doc/Caricature/Expectation.html",
     "doc/Caricature/ExpectationBuilder.html",
     "doc/Caricature/ExpectationSyntax.html",
     "doc/Caricature/Expectations.html",
     "doc/Caricature/Interception.html",
     "doc/Caricature/Interception/ClassMethods.html",
     "doc/Caricature/Isolation.html",
     "doc/Caricature/Isolator.html",
     "doc/Caricature/MemberDescriptor.html",
     "doc/Caricature/Messenger.html",
     "doc/Caricature/MethodCallRecorder.html",
     "doc/Caricature/MethodCallRecording.html",
     "doc/Caricature/RubyIsolator.html",
     "doc/Caricature/RubyMessenger.html",
     "doc/Caricature/RubyObjectDescriptor.html",
     "doc/Caricature/TypeDescriptor.html",
     "doc/Caricature/Verification.html",
     "doc/Class.html",
     "doc/Hash.html",
     "doc/Module.html",
     "doc/Object.html",
     "doc/README_markdown.html",
     "doc/String.html",
     "doc/System.html",
     "doc/System/String.html",
     "doc/System/Type.html",
     "doc/created.rid",
     "doc/images/brick.png",
     "doc/images/brick_link.png",
     "doc/images/bug.png",
     "doc/images/bullet_black.png",
     "doc/images/bullet_toggle_minus.png",
     "doc/images/bullet_toggle_plus.png",
     "doc/images/date.png",
     "doc/images/find.png",
     "doc/images/loadingAnimation.gif",
     "doc/images/macFFBgHack.png",
     "doc/images/package.png",
     "doc/images/page_green.png",
     "doc/images/page_white_text.png",
     "doc/images/page_white_width.png",
     "doc/images/plugin.png",
     "doc/images/ruby.png",
     "doc/images/tag_green.png",
     "doc/images/wrench.png",
     "doc/images/wrench_orange.png",
     "doc/images/zoom.png",
     "doc/index.html",
     "doc/js/darkfish.js",
     "doc/js/jquery.js",
     "doc/js/quicksearch.js",
     "doc/js/thickbox-compressed.js",
     "doc/lib/caricature/clr/aspnet_mvc_rb.html",
     "doc/lib/caricature/clr/descriptor_rb.html",
     "doc/lib/caricature/clr/isolation_rb.html",
     "doc/lib/caricature/clr/isolator_rb.html",
     "doc/lib/caricature/clr/messenger_rb.html",
     "doc/lib/caricature/clr_rb.html",
     "doc/lib/caricature/descriptor_rb.html",
     "doc/lib/caricature/expectation_rb.html",
     "doc/lib/caricature/isolation_rb.html",
     "doc/lib/caricature/isolator_rb.html",
     "doc/lib/caricature/messaging_rb.html",
     "doc/lib/caricature/messenger_rb.html",
     "doc/lib/caricature/method_call_recorder_rb.html",
     "doc/lib/caricature/verification_rb.html",
     "doc/lib/caricature_rb.html",
     "doc/lib/core_ext/array_rb.html",
     "doc/lib/core_ext/class_rb.html",
     "doc/lib/core_ext/core_ext_rb.html",
     "doc/lib/core_ext/hash_rb.html",
     "doc/lib/core_ext/module_rb.html",
     "doc/lib/core_ext/object_rb.html",
     "doc/lib/core_ext/string_rb.html",
     "doc/lib/core_ext/system/string_rb.html",
     "doc/lib/core_ext/system/type_rb.html",
     "doc/rdoc.css",
     "irb_init.rb",
     "lib/bin/Workarounds.dll",
     "lib/bin/Workarounds.pdb",
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
     "lib/core_ext/array.rb",
     "lib/core_ext/class.rb",
     "lib/core_ext/core_ext.rb",
     "lib/core_ext/hash.rb",
     "lib/core_ext/module.rb",
     "lib/core_ext/object.rb",
     "lib/core_ext/string.rb",
     "lib/core_ext/system/string.rb",
     "lib/core_ext/system/type.rb",
     "pkg/.gitignore",
     "pkg/caricature-0.1.0.gem",
     "pkg/caricature-0.5.0.gem",
     "pkg/caricature-0.6.0.gem",
     "spec/bacon_helper.rb",
     "spec/bin/.gitignore",
     "spec/core_ext_spec.rb",
     "spec/descriptor_spec.rb",
     "spec/expectation_spec.rb",
     "spec/integration_spec.rb",
     "spec/interop_spec.rb",
     "spec/isolation_spec.rb",
     "spec/isolator_spec.rb",
     "spec/messaging_spec.rb",
     "spec/method_call_spec.rb",
     "spec/models/ClrModels.cs",
     "spec/sword_spec.rb",
     "spec/verification_spec.rb",
     "workarounds/ReflectionHelper.cs"
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
     "spec/descriptor_spec.rb",
     "spec/expectation_spec.rb",
     "spec/integration_spec.rb",
     "spec/interop_spec.rb",
     "spec/isolation_spec.rb",
     "spec/isolator_spec.rb",
     "spec/messaging_spec.rb",
     "spec/method_call_spec.rb",
     "spec/sword_spec.rb",
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
