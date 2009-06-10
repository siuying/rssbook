Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.name = 'rssbook'
  s.version = '0.1.4'
  s.date = '2009-06-10'

  s.summary = s.description = "Convert RSS Feed to PDF format."

  s.author = "siuying"
  s.email = "siu.ying@gmail.com"

  # = MANIFEST =
  s.files = %w[
    LICENSE
    README
    Rakefile
    bin/rssbook
    lib/rssbook.rb
    rssbook.gemspec
  ]
  # = MANIFEST =

  s.extra_rdoc_files = %w[README LICENSE]
  s.add_dependency 'prawn'
  s.add_dependency 'hpricot'
  s.has_rdoc = false
  s.executables = ["rssbook"]
  s.require_paths = %w[lib]
  s.rubygems_version = '1.1.1'
  
end