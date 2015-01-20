require_relative "../test_helper"
require "irc/rfc2812/whois"
require "irc/rfc2812/message"

def msg(*args)
  IRC::RFC2812::Message.new *args
end

MESSAGES = [
  msg(":prefix 311 x nick user host.com * :real name\r\n"), # RPL_WHOISUSER
  msg(":prefix 319 x nick :@#one +#two ##three ++four\r\n"),# RPL_WHOISCHANNELS
  msg(":prefix 312 x nick server.com :server info"),        # RPL_WHOISSERVER
  msg(":prefix 301 x nick :away message\r\n"),              # RPL_AWAY
  msg(":prefix 313 x nick :is an IRC operator\r\n"),        # RPL_WHOISOPERATOR
  msg(":prefix 317 x nick 15 :seconds idle\r\n"),           # RPL_WHOISIDLE
  msg(":prefix 318 x nick :End of WHOIS list\r\n")          # RPL_ENDOFWHOIS
]

setup { IRC::RFC2812::Whois.new(*MESSAGES) }

# RPL_WHOISUSER

test "#nick" do |whois|
  assert_equal whois.nick, "nick"
end

test "#user" do |whois|
  assert_equal whois.user, "user"
end

test "#host" do |whois|
  assert_equal whois.host, "host.com"
end

test "#realname" do |whois|
  assert_equal whois.realname, "real name"
end

# RPL_WHOISCHANNELS

test "#channels" do |whois|
  assert_equal whois.channels, ["#one", "#two", "##three", "++four"]
end

test "#channels with a status symbol" do |whois|
  assert_equal whois.channels("@"), ["#one"]
  assert_equal whois.channels(:+),  ["#two"]
  assert_equal whois.channels(nil), ["##three", "++four"]
end

test "#statuses" do |whois|
  assert_equal whois.statuses, "#one" => :"@", "#two" => :+, "##three" => nil, 
                               "++four" => nil
end

# RPL_WHOISSERVER

test "the server" do |whois|
  assert_equal whois.server, "server.com"
end

test "server info" do |whois|
  assert_equal whois.server_info, "server info"
end

# RPL_AWAY

test "#away? (while away)" do |whois|
  assert_equal whois.away?, true
end

test "#away? (while not away)" do |whois|
  whois = whois.class.new(MESSAGES.last)

  assert_equal whois.away?, false
end

# RPL_WHOISOPERATOR

test "#operator? (while operator)" do |whois|
  assert_equal whois.operator?, true
end

test "#operator? (while not operator)" do |whois|
  whois = whois.class.new(MESSAGES.last)

  assert_equal whois.operator?, false
end

# RPL_WHOISIDLE

test "idle time" do |whois|
  assert_equal whois.seconds_idle, 15
end
