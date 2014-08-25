require_relative "../test_helper"
require "irc/message"

class Test < IRC::Message
  def self.parse(*_)
    ["prefix", "001", ["one", "two", "three", "the trail"]]
  end
end

setup { Test.new ":prefix 001 one two three :the trail" }

# Message parts

test "the raw message" do |message|
  assert_equal message.raw, ":prefix 001 one two three :the trail"
end

test "the prefix" do |message|
  assert_equal message.prefix, "prefix"
end

test "the command" do |message|
  assert_equal message.command, :"001"
end

test "the parameters" do |message|
  assert_equal message.params, ["one", "two", "three", "the trail"]
end

test "the trail" do |message|
  assert_equal message.trail, "the trail"
end

test "the time" do |message|
  assert_equal message.time.class, Time
end

# Equality operators

test "#==" do |message|
  assert message == "the trail"
end

test "#=~" do |message|
  assert message =~ /trail/
end

test "#<=>" do |message|
  other = Test.new("")
  
  assert_equal message <=> other,    -1
  assert_equal message <=>  message,  0
  assert_equal other <=> message,     1
  assert_equal message <=> 0, nil
end

test "#match" do |message|
  assert      message.match :"001"
  assert (not message.match :"002")

  assert      message.match "001"
  assert (not message.match "002")

  assert      message.match 001
  assert (not message.match 002)

  assert      message.match :"001", "the trail"
  assert (not message.match :"001", "the trial")
  
  assert      message.match :"001", /trail/
  assert (not message.match :"001", /trial/)

  assert      message.match :"001", *%w(one two three), "the trail"
  assert (not message.match :"001", *%w(three two one), "the trail")

  message.match :"001", /the (\S+)/ do |capture|
    assert_equal capture, "trail"
  end
end

# Conversions

test "#to_a" do |message|
  assert_equal message.to_a, ["prefix", :"001", ["one", "two", "three", "the trail"]]
end

test "#to_h" do |message|
  assert_equal message.to_h, {
    :prefix     => "prefix",
    :command    => :"001",
    :parameters => ["one", "two", "three", "the trail"],
    :trail      => "the trail"
  }
end

test "#to_s" do |message|
  assert_equal message.to_s, "the trail"
end

test "#to_str" do |message|
  assert_equal message.to_str, "the trail"
end

test "#to_sym" do |message|
  assert_equal message.to_sym, :"001"
end


class Colored < IRC::Message
  def self.parse(message)
    ["", "COMMAND", [message.split(":").last]]
  end
end

test "#strip_colors" do
  msg = Colored.new "COMMAND :a \x0301,01b\x03 c \x0315,15d\x03 e \x0301f\x03 g"

  assert_equal msg.strip_colors, "a b c d e f g" # #== works like this
end
