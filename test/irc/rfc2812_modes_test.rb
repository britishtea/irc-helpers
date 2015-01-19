require_relative "../test_helper"
require "irc/rfc2812/message"
require "irc/rfc2812/modes"

def msg(*args)
  IRC::RFC2812::Message.new *args
end

setup do
  IRC::RFC2812::Modes
end

test "default values" do |klass|
  modes = klass.new msg(":server.com 324 banter #channel +")

  # Modes without parameters
  assert_equal modes[:n], false
  assert_equal modes[:t], false

  # Modes with parameters
  assert_equal modes[:l], false
  assert_equal modes[:k], false

  # Lists
  assert_equal modes[:b], []
  assert_equal modes[:e], []
  assert_equal modes[:I], []
end

test "modes without a parameter" do |klass|
  modes = klass.new msg(":server.com 324 banter #channel +nt")

  assert_equal modes[:n], true
  assert_equal modes[:t], true
end

test "modes with a parameter" do |klass|
  modes = klass.new msg(":server.com 324 banter #channel +klnt password 100")

  assert_equal modes[:k], "password"
  assert_equal modes[:l], "100"
end

test "lists" do |klass|
  # Ban list
  modes = klass.new msg(":server.com 367 banter #channel *!user@*"),
                    msg(":server.com 367 banter #channel nick!*@*"),
                    msg(":server.com 368 banter #channel :End of channel ban list")

  assert_equal modes[:b], ["*!user@*", "nick!*@*"]

  # Ban exception list
  modes = klass.new msg(":server.com 348 banter #channel *!user@*"),
                    msg(":server.com 348 banter #channel nick!*@*"),
                    msg(":server.com 349 banter #channel :End of channel exception list")

  assert_equal modes[:e], ["*!user@*", "nick!*@*"]


  # Invite exception list
  modes = klass.new msg(":server.com 346 banter #channel *!user@*"),
                    msg(":server.com 346 banter #channel nick!*@*"),
                    msg(":server.com 347 banter #channel :End of channel invite list")

  assert_equal modes[:I], ["*!user@*", "nick!*@*"]
end
