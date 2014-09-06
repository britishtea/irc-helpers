require_relative "../test_helper"
require "irc/isupport"
require "irc/rfc2812/message"

setup do
  a = ":pre 005 CASEMAPPING=rfc1459 CHANLIMIT=#+:10,&: CHANMODES=b,k,l,imnpst " +
  "CHANNELLEN=50 CHANTYPES=+#& EXCEPT=e IDCHAN=!:5 INVEX=I KICKLEN=50 " +
  ":are supported by this server"
  b = ":pre 005 MAXLIST=b:25,eI:50 MODES=3 NETWORK=EFnet NICKLEN=9 " +
  "PREFIX=(ohv)@%+ SAFELIST STATUSMSG=@+ STD=rfcnnnn " +
  "TARGMAX=PRIVMSG:4,NOTICE:3 TOPICLEN=50 :are supported by this server"

  messages = [a, b].map { |msg| IRC::RFC2812::Message.new msg }
  
  IRC::ISupport.new *messages
end

# Per ISupport draft as described here:
# http://www.irc.org/tech_docs/draft-brocklesby-irc-isupport-03.txt

test "get the casemapping" do |isupport|
  assert_equal isupport.casemapping, :rfc1459
end

test "default value for casemapping" do |isupport|
  assert_equal isupport.class.new.casemapping, :rfc1459
end

test "get the channel limit" do |isupport|
  expected = { "#" => 10, "+" => 10, "&" => Float::INFINITY }
  assert_equal isupport.channel_limits, expected
end

test "default value for channel limits" do |isupport|
  assert_equal isupport.class.new.channel_limits, {}
end

test "get the channel modes" do |isupport|
  expected = {
    :A => ["b"],
    :B => ["k"],
    :C => ["l"],
    :D => ["i", "m", "n", "p", "s", "t"]
  }

  assert_equal isupport.channel_modes, expected
end

test "get the channel length" do |isupport|
  assert_equal isupport.channel_length, 50
end

test "default value for channel length" do |isupport|
  assert_equal isupport.class.new.channel_length, 200
end

test "get the channel types" do |isupport|
  assert_equal isupport.channel_types, ["+", "#", "&"]
end

test "default value for channel types" do |isupport|
  assert_equal isupport.class.new.channel_types, ["#", "&"]
end

test "check if exception lists are supported" do |isupport|
  assert_equal isupport.exceptions?, true
end

test "default value for exceptions" do |isupport|
  assert_equal isupport.class.new.exceptions?, false
end

test "get the exception list mode character" do |isupport|
  assert_equal isupport.exception_mode, "e"
end

test "default value for exception mode character" do |isupport|
  assert_equal isupport.class.new.exception_mode, nil
end

test "get the channel ID lengths" do |isupport|
  assert_equal isupport.channel_id_lengths, { "!" => 5 }
end

test "default value for channel ID lengths" do |isupport|
  assert_equal isupport.class.new.channel_id_lengths, {}
end

test "check if invite exceptions are supported" do |isupport|
  assert_equal isupport.invite_exceptions?, true
end

test "default value for invite exceptions" do |isupport|
  assert_equal isupport.class.new.invite_exceptions?, false
end

test "get the invite exception mode character" do |isupport|
  assert_equal isupport.invite_exception_mode, "I"
end

test "default value for invite exception mode character" do |isupport|
  assert_equal isupport.class.new.invite_exception_mode, nil
end

test "get the kick message length" do |isupport|
  assert_equal isupport.kick_length, 50
end

test "get the maxlist" do |isupport|
  assert_equal isupport.max_list_items, { :b => 25, :e => 50, :I => 50 }
end

test "get the maximum number of modes per MODE command" do |isupport|
  assert_equal isupport.max_modes, 3
end

test "default value for maximum number of modes per MODE command" do |isupport|
  assert_equal isupport.class.new.max_modes, 3
end

test "get the network" do |isupport|
  assert_equal isupport.network, "EFnet"
end

test "default value for the network" do |isupport|
  assert_equal isupport.class.new.network, nil
end

test "get the maximum nickname length" do |isupport|
  assert_equal isupport.nick_length, 9
end

test "get the user prefixes" do |isupport|
  assert_equal isupport.prefix, { "o" => "@", "h" => "%", "v" => "+" }
end

test "default value for user prefixes" do |isupport|
  assert_equal isupport.class.new.prefix, { "o" => "@", "v" => "+" }
end

test "check if a LIST command can safely be send" do |isupport|
  assert_equal isupport.list?, true
end

test "default value for safelist stuff" do |isupport|
  assert_equal isupport.class.new.list?, false
end

test "check if the server supports \"status messages\"" do |isupport|
  assert_equal isupport.status_messages?, true
end

test "default value for \"status message\" support" do |isupport|
  assert_equal isupport.class.new.status_messages?, false
end

test "get the statuses that support \"status messages\"" do |isupport|
  assert_equal isupport.status_messages, ["@", "+"]
end

test "default value for \"status message\" support" do |isupport|
  assert_equal isupport.class.new.status_messages, []
end

test "get the supported versions of the ISupport standard" do |isupport|
  assert_equal isupport.standards, ["rfcnnnn"]
end

test "default value for supported versions of ISupport standard" do |isupport|
  assert_equal isupport.class.new.standards, []
end

test "get the maximum number of targets for commands" do |isupport|
  assert_equal isupport.maximum_targets, { :privmsg => 4, :notice => 3 }
end

test "default value of maximum number of targets for commands" do |isupport|
  assert_equal isupport.class.new.maximum_targets, {}
end

test "get the maximum topic length" do |isupport|
  assert_equal isupport.topic_length, 50
end

test "default value for maximum topic length" do |isupport|
  assert_equal isupport.class.new.topic_length, Float::INFINITY
end

# TODO: Implement extensions to the ISupport standard as described here:
# http://www.irc.org/tech_docs/005.html
