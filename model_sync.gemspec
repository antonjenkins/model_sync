# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{model_sync}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anton Jenkins"]
  s.date = %q{2009-07-20}
  s.description = %q{Sync changes to an ActiveRecord model to another model}
  s.email = %q{info@pixellatedvisions.com}
  s.extra_rdoc_files = ["lib/model_sync.rb", "README.rdoc"]
  s.files = ["lib/model_sync.rb", "Rakefile", "README.rdoc", "Manifest", "model_sync.gemspec"]
  s.homepage = %q{http://github.com/antonjenkins/model_sync}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Model_sync", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{model_sync}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Sync changes to an ActiveRecord model to another model}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
