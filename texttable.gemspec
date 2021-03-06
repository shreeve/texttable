# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = "texttable"
  s.version     = "1.1.9"
  s.author      = "Steve Shreeve"
  s.email       = "steve.shreeve@gmail.com"
  s.summary     = "An easy way to work with rows and columns as simple tables"
  s.description = "This gem will auto-size based on column widths."
  s.homepage    = "https://github.com/shreeve/texttable"
  s.license     = "MIT"
  s.files       = `git ls-files`.split("\n") - %w[.gitignore]
end
