require_relative "../test_helper"
require "irc/rfc2812/message"

setup { IRC::RFC2812::Message.new ":prefix COMMAND para meter :the trail\r\n" }

test "#prefix returns an IRC::RFC2812::Prefix" do |message|
  assert_equal message.prefix.class, IRC::RFC2812::Prefix
end

test ".parse is implemented" do |message|
  assert_equal message.class.parse("PING").class, Array
end

test "#valid? is implemented" do |message|
  assert message.valid?
end

test "#numeric?" do |message|
  assert      message.class.new("001").numeric?
  assert (not message.numeric?)
end

# Error replies are found in the range from 400 to 599.
test "#error?" do |message|
  assert      message.class.new("404").error?
  assert (not message.class.new("399").error?)
  assert (not message.class.new("600").error?)
  assert (not message.error?)
end
