require_relative "../test_helper"
require "irc/rfc2812/message"

setup { IRC::RFC2812::Message.new ":prefix COMMAND para meter :the trail\r\n" }

test ".parse is implemented" do |message|
  assert_equal message.class.parse("PING").class, Array
end

test "#valid? is implemented" do |message|
  assert message.valid?
end
