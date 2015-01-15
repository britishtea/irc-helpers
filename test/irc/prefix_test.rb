require_relative "../test_helper"
require "irc/prefix"

setup { IRC::Prefix.new("nick", "user", "host.com") }

prepare { $mask = IRC::Prefix.new("n?ck", nil, "h*st.com") }

test "initializing with a host mask String" do
  assert_raise { IRC::Prefix.new("nick!user@host.com") }
end

# Prefix parts

test "#raw" do |prefix|
  assert_equal prefix.raw, "nick!user@host.com"
end

test "#nick" do |prefix|
  assert_equal prefix.nick, "nick"
end

test "#user" do |prefix|
  assert_equal prefix.user, "user"
end

test "#host" do |prefix|
  assert_equal prefix.host, "host.com"
end

# Equality operators

test "#== without wildcards" do |prefix|
  assert prefix == "nick!user@host.com"
  assert prefix == "NICK!user@host.com"
  assert prefix == prefix
end

test "#== with wildcards" do
  assert (not $mask == "nick!user@host.com")
  assert (not $mask == "NICK!user@host.com")
end

test "#=~ without wildcards" do |prefix|
  assert prefix =~ "nick!user@host.com"
  assert prefix =~ "NICK!user@host.com"
  assert prefix =~ prefix
end

test "#=~ with wildcards" do
  assert      $mask =~ "nick!user@host.com"
  assert      $mask =~ "nack!user@haast.com"
  assert (not $mask =~ "naack!user@haast.com") # ? matches a single character
end

test "#eql?" do |prefix|
  assert      prefix.eql? prefix
  assert (not prefix.eql? $mask)

  assert      $mask.eql? $mask
  assert (not $mask.eql? prefix)
end

test "#hash" do |prefix|
  assert_equal prefix.hash, prefix.class.new("nick", "user", "host.com").hash
  assert (not prefix.hash == $mask.hash)
end

# Conversions

test "#to_regexp" do |prefix|
  assert_equal prefix.to_regexp, /^nick!user@host\.com$/i
  assert_equal $mask.to_regexp, /^n\Sck!\S*@h\S*st\.com$/i
end

test "#to_s" do |prefix|
  assert_equal prefix.to_s, "nick!user@host.com"
end

test "#to_str" do |prefix|
  assert_equal prefix.to_str, "nick!user@host.com"
end
