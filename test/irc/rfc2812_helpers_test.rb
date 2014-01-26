require_relative "../test_helper"
require "irc/rfc2812/helpers"

setup { IRC::RFC2812::Helpers }

test "#parse" do |helpers|
  input  = ":prefix COMMAND param param :the trail\r\n"
  output = ["prefix", "COMMAND", ["param", "param", "the trail"]]
  assert_equal helpers.parse(input), output

  input  = "COMMAND param param :the trail\r\n"
  output = [nil, "COMMAND", ["param", "param", "the trail"]]
  assert_equal helpers.parse(input), output

  input  = ":prefix COMMAND param param\r\n"
  output = ["prefix", "COMMAND", ["param", "param"]]
  assert_equal helpers.parse(input), output

  input  = "COMMAND param param\r\n"
  output = [nil, "COMMAND", ["param", "param"]]
  assert_equal helpers.parse(input), output

  input  = ":prefix COMMAND :the trail\r\n"
  output = ["prefix", "COMMAND", ["the trail"]]
  assert_equal helpers.parse(input), output

  input  = "COMMAND :the trail\r\n"
  output = [nil, "COMMAND", ["the trail"]]
  assert_equal helpers.parse(input), output

  input  = ":prefix COMMAND\r\n"
  output = ["prefix", "COMMAND", []]
  assert_equal helpers.parse(input), output

  input  = "COMMAND\r\n"
  output = [nil, "COMMAND", []]
  assert_equal helpers.parse(input), output
end

test "#valid?" do |helpers|
  # More than 15 parameters.
  input = ":prefix COMMAND p p p p p p p p p p p p p p p p p p p p p :trail\r\n"
  assert !helpers.valid?(input)

  # Whitespace between the colon and prefix.
  assert !helpers.valid?(": prefix COMMAND para meter :trail\r\n")

  # Invalid IRC command.
  assert !helpers.valid?(":prefix downcase para meter :trail\r\n")
  assert !helpers.valid?(":prefix 8======> para meter :trail\r\n")

  # Not terminated with a CR-LF.
  assert !helpers.valid?(":prefix COMMAND para meter :trail")

  # Longer than 512 characters
  assert !helpers.valid?(":prefix COMMAND param :  the trail the trail the " \
    "trail the trail the trail the trail the trail the trail the trail the " \
    "trail the trail the trail the trail the trail the trail the trail the " \
    "trail the trail the trail the trail the trail the trail the trail the " \
    "trail the trail the trail the trail the trail the trail the trail the " \
    "trail the trail the trail the trail the trail the trail the trail the " \
    "trail the trail the trail the trail the trail the trail the trail the " \
    "trail the trail the trail the trail the trail\r\n")

  # Includes a NUL character.
  assert !helpers.valid?(":prefix COMMAND para meter :the trail \x00\r\n")

  # Hostname is longer than 63 characters.
  hostname = "this.is.quite.a.long.host.name.its.exactly.sixty.four.characters"
  assert !helpers.valid?(":nick!user@#{hostname} COMMAND\r\n")
  assert !helpers.valid?("#{hostname} COMMAND\r\n")

  assert helpers.valid?(":prefix COMMAND para meter :the trail\r\n")
end
