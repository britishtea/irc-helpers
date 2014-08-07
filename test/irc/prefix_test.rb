require_relative "../test_helper"
require "irc/prefix"

TestPrefix = Class.new IRC::Prefix do
  define_singleton_method(:parse) { |*_| ["nick", "user", "host.com"] }
end

TestMask = Class.new IRC::Prefix do
  define_singleton_method(:parse) { |*_| ["n?ck", "*", "h*st.com"] }
end

setup { TestPrefix.new "" }

# Prefix parts

test "the raw prefix" do |prefix|
  assert_equal prefix.raw, ""
end

test "the nick" do |prefix|
  assert_equal prefix.nick, "nick"
end

test "the user" do |prefix|
  assert_equal prefix.user, "user"
end

test "the host" do |prefix|
  assert_equal prefix.host, "host.com"
end

# Equality operators

test "#== without wildcards" do |prefix|
  assert prefix == "nick!user@host.com"
  assert prefix == "NICK!user@host.com"
  assert prefix == prefix
end

test "#== with wildcards" do
  mask = TestMask.new "n?ck!*@h*st.com"

  assert (not mask == "nick!user@host.com")
  assert (not mask == "NICK!user@host.com")
end

test "#=~ without wildcards" do |prefix|
  assert prefix =~ "nick!user@host.com"
  assert prefix =~ "NICK!user@host.com"
  assert prefix =~ prefix
end

test "#=~ with wildcards" do
  mask = TestMask.new "n?ck!*@h*st.com"

  assert      mask =~ "nick!user@host.com"
  assert      mask =~ "nack!user@haast.com"
  assert (not mask =~ "naack!user@haast.com") # ? matches a single character
end

# Conversions

test "to_a" do |prefix|
  assert_equal prefix.to_a, ["nick", "user", "host.com"]
end

test "to_h" do |prefix|
  assert_equal prefix.to_h, { 
    :nick => "nick", 
    :user => "user", 
    :host => "host.com"
  }
end

test "to_regexp" do |prefix|
  mask = TestMask.new "n?ck!*@h*st.com"

  assert_equal prefix.to_regexp, /^nick!user@host\.com$/i
  assert_equal mask.to_regexp, /^n\Sck!\S*@h\S*st\.com$/i
end

test "to_s" do |prefix|
  assert_equal prefix.to_s, "nick!user@host.com"
end

test "to_str" do |prefix|
  assert_equal prefix.to_str, "nick!user@host.com"
end