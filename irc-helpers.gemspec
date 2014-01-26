$:.unshift File.expand_path("../lib", __FILE__)
require "irc/version"

Gem::Specification.new do |s|
  s.name          = "irc-helpers"
  s.version       = IRC::VERSION
  s.summary       = "The IRC protocol implemented as a Ruby mixin"
  s.description   = "The IRC protocol implemented as a Ruby mixin"
  s.authors       = ["Jip van Reijsen"]
  s.email         = ["jipvanreijsen@gmail.com"]
  s.homepage      = "https://github.com/britishtea/irc-helpers"
  s.license       = "MIT"

  s.files         = `git ls-files app lib`.split("\n")
  s.require_paths = ["lib"]

  s.signing_key   = File.expand_path "~/.gem/gem-private_key.pem"
  s.cert_chain    = ["certs/britishtea.pem"]

  s.add_development_dependency "cutest", "~> 1.2.0"
end
