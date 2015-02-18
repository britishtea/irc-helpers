require_relative "../test_helper"
require "irc/rfc2812/message"

def msg(message)
  IRC::RFC2812::Message.new(message)
end

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

test "#target_channel" do
  positives = [
    msg(":prefix JOIN #channel\r\n"),
    msg(":prefix PART #channel :Reason\r\n"),
    msg(":prefix MODE #channel -l\r\n"),
    msg(":prefix TOPIC #channel :Topic\r\n"),
    msg(":prefix INVITE user #channel\r\n"),
    msg(":prefix KICK #channel user :Reason\r\n"),
    msg(":prefix PRIVMSG #channel :Message\r\n"),
    msg(":prefix NOTICE #channel :Notice\r\n"),
    msg(":prefix 353 us = #channel :@user +other_user\r\n"),
    msg(":prefix 441 us user #channel :They aren't on that channel\r\n"),
    msg(":prefix 443 us user #channel :is already on channel\r\n"),
    msg(":prefix 472 us <char> :is unknown mode char to me for #channel\r\n"),
  ]

  positives.each do |message|
    assert_equal message.target_channel, "#channel"
  end

  negatives = [
    msg(":prefix NICK user\r\n"),
    msg(":prefix QUIT :Reason\r\n"),
    msg(":prefix SQUIT :Reason\r\n"),
    msg(":prefix PRIVMSG user :Message\r\n"),
    msg(":prefix NOTICE user :Notice\r\n"),
  ]

  negatives.each do |message|
    assert_equal message.target_channel, nil
  end 
end
