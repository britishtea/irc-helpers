require_relative "../test_helper"
require "irc/message"

class Test < IRC::Message
  def self.parse(*_)
    ["prefix", "001", ["one", "two", "three"], "the trail"]
  end
end

setup { Test.new ":prefix 001 one two three :the trail" }

prepare { $test = nil }

# Message parts

test "#raw" do |message|
  assert_equal message.raw, ":prefix 001 one two three :the trail"
end

test "#prefix" do |message|
  assert_equal message.prefix, "prefix"
end

test "#command" do |message|
  assert_equal message.command, :"001"
end

test "#parameters" do |message|
  assert_equal message.params, ["one", "two", "three"]
end

test "#trail" do |message|
  assert_equal message.trail, "the trail"

  without_trail = Class.new(message.class) do |variable|
    def self.parse(*_)
      ["prefix", "001", ["one", "two", "three"], nil]
    end
  end

  message = without_trail.new ":prefix 001 one two three"

  assert_equal message.trail, nil
end

test "#time" do |message|
  assert_equal message.time.class, Time
end

# Equality operators

test "#==" do |message|
  assert message == "the trail"
  assert message == message.class.new(":prefix 001 one two three :the trail")
  assert_equal message == message.class.new("PRIVMSG #chan :the trail"), false
end

test "#=~" do |message|
  assert message =~ /trail/
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
end

test "#match with a block" do |message|
  message.match(:"001") { $test = true }
  message.match(:"002") { $test = false }
  
  assert_equal $test, true

  # Command as String
  assert      message.match "001"
  assert (not message.match "002")

  message.match("001") { $test = true }
  message.match("002") { $test = false }
  
  assert_equal $test, true

  # Command as Integer
  assert      message.match 001
  assert (not message.match 002)

  message.match(001) { $test = true }
  message.match(002) { $test = false }
  
  assert_equal $test, true
end

test "#match command and pattern" do |message|
  # Pattern as String
  assert      message.match :"001", "the trail"
  assert (not message.match :"001", "the trial")

  message.match(:"001", "the trail") { $test = true }
  message.match(:"001", "the trial") { $test = false }

  assert_equal $test, true


  # Pattern as a Regexp with captures
  message.match(:"001", /the (\S)(\S+)/) { |*captures| $test = captures }
  
  assert_equal $test, ["t", "rail"]
end

# Conversions

test "#to_s" do |message|
  assert_equal message.to_s, "the trail"
end

test "#to_str" do |message|
  assert_equal message.to_str, "the trail"
end


class Colored < IRC::Message
  def self.parse(message)
    ["", "COMMAND", [], message.split(":").last]
  end
end

test "#strip_colors" do
  msg = Colored.new "COMMAND :a \x0301,01b\x03 c \x0315,15d\x03 e \x0301f\x03 g"

  assert msg.strip_colors.object_id != msg.object_id
  assert_equal msg.strip_colors, "a b c d e f g" # #== works like this
end
