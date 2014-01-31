require_relative "../test_helper"
require "irc/rfc2812/prefix"

setup { IRC::RFC2812::Prefix.new "nick!user@host.com" }

test ".parse is implemented" do |prefix|
  assert_equal prefix.class.parse("nick").class, Array
end

test "#valid? is implemented" do |prefix|
  assert prefix.valid?
end
