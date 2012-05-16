# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sql_parser/version"

Gem::Specification.new do |s|
  s.name        = "sql_parser"
  s.version     = SqlParser::VERSION
  s.authors     = ["Jonatan Reiners"]
  s.email       = ["git@encc.de"]
  s.homepage    = ""
  s.summary     = %q{converts sql language dialects}
  s.description = %q{uses treetop and therefore understands sql}

  s.rubyforge_project = "sql_parser"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-given"
  s.add_development_dependency "guard"
  s.add_runtime_dependency "treetop"
  s.add_runtime_dependency "beanstalk-client"
  s.add_runtime_dependency "mongo_mapper"
  s.add_runtime_dependency "bson_ext"
  # s.add_runtime_dependency "rest-client"
end
