require_relative "../test_helper"
require "irc/rfc2812/prefix"

setup { IRC::RFC2812::Prefix.new "nick!user@host.com" }

test ".parse is implemented" do |prefix|
  assert_equal prefix.class.parse("nick").class, Array
end

test "#valid? is implemented" do |prefix|
  assert prefix.valid?
end

test "#== for scandinavians" do
  prefix = IRC::RFC2812::Prefix.new "{}|^abc[]\\~!user@host.com"

  assert prefix == "{}|^abc{}|^!user@host.com"
  assert prefix == "{}|^abc[]\\~!user@host.com"
  assert prefix == "[]\\~abc{}|^!user@host.com"
  assert prefix == "[]\\~abc[]\\~!user@host.com"
end

test "#=~ for scandinavians" do
  prefix = IRC::RFC2812::Prefix.new "{}|^abc[]\\~!user@host.com"

  assert prefix =~ "{}|^abc{}|^!user@host.com"
  assert prefix =~ "{}|^abc[]\\~!user@host.com"
  assert prefix =~ "[]\\~abc{}|^!user@host.com"
  assert prefix =~ "[]\\~abc[]\\~!user@host.com"
end

test "#to_regexp for scandinavians" do
  prefix = IRC::RFC2812::Prefix.new "{}|^abc[]\\~!user@host.com"

  assert_equal prefix.to_regexp, # this is motherflippin ridiculous.
  /^(\[|\{)(\]|\})(\\|\|)(~|\^)abc(\[|\{)(\]|\})(\\|\|)(~|\^)!user@host\.com$/i
end
