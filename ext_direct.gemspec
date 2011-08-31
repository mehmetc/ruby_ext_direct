# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ext_direct/version"

Gem::Specification.new do |s|
  s.name        = "ext_direct"
  s.version     = ExtDirect::VERSION
  s.authors     = ["Mehmet Celik"]
  s.email       = ["mehmet@celik.be"]
  s.homepage    = ""
  s.summary     = %q{Ext.direct}
  s.description = %q{Ext.direct}

  s.rubyforge_project = "ext_direct"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
