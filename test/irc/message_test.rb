require_relative "../test_helper"
require "irc/message"

class Test < IRC::Message
  def parse(_)
    ["prefix", "COMMAND", ["one", "two", "three", "the trail"]]
  end
end

setup { Test.new "" }

# Message parts

test "the raw message" do |message|
  assert_equal message.raw, ""
end

test "the prefix" do |message|
  assert_equal message.prefix, "prefix"
end

test "the command" do |message|
  assert_equal message.command, :command
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

# Conversions

test "#to_a" do |message|
  assert_equal message.to_a, ["prefix", :command, ["one", "two", "three", "the trail"]]
end

test "#to_h" do |message|
  assert_equal message.to_h, {
    :prefix     => "prefix",
    :command    => :command,
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
  assert_equal message.to_sym, :command
end
