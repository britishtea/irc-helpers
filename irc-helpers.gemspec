$:.unshift File.expand_path('../lib', __FILE__)
require 'irc/version'

Gem::Specification.new do |s|
  s.name          = "irc-helpers"
  s.version       = IRC::VERSION
  s.summary       = "The IRC protocol implemented as a Ruby mixin"
  s.description   = "The IRC protocol implemented as a Ruby mixin"
  s.authors       = ["Jip van Reijsen"]
  s.email         = ["jipvanreijsen@gmail.com"]
  s.homepage      = "https://github.com/britishtea/irc-helpers"

  s.files         = `git ls-files app lib`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency "cutest", "~> 1.2.0"
end
