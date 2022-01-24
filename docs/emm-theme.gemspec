# frozen_string_literal: true
# based heavily on the IIIF-C theme

Gem::Specification.new do |spec|
  spec.name          = "emm-theme"
  spec.version       = "0.1.0"
  spec.authors       = ["EMM"]
  spec.email         = ["admin@eem.io"]

  spec.summary       = %q{Jekyll gem theme for Entity Metadata Management web properties.}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["plugin_type"] = "theme"

  spec.files = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r!^(assets|lib|_(includes|layouts|sass|data)/|(LICENSE|README)((\.(txt|md|markdown)|$)))!i)
  end

  spec.add_runtime_dependency "html-proofer"
  spec.add_runtime_dependency "jekyll", ">= 4.0", "< 4.2"
  spec.add_runtime_dependency "jekyll-data"
  spec.add_runtime_dependency "jekyll-gzip"
  spec.add_runtime_dependency "jekyll-redirect-from"
  spec.add_runtime_dependency "jekyll-sitemap"
  spec.add_runtime_dependency "jekyll-liquify"
  spec.add_runtime_dependency "rake"
end
