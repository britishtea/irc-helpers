require_relative "../test_helper"
require "irc/rfc2812/commands"

test "module as receiver" do
  mod = IRC::RFC2812::Commands

  assert mod.respond_to? :privmsg
  assert mod.respond_to? :raw

  privmsg = mod.privmsg("#channel", "message")
  assert_equal privmsg, "PRIVMSG #channel :message\r\n"
end

setup do
  Object.new.tap do |obj| 
    obj.extend IRC::RFC2812::Commands
    def obj.raw(message); message; end
  end
end

# Connection registration

test "#pass" do |c|
  assert_equal c.pass("pass"), "PASS pass\r\n"
end
  
test "#nick" do |c|
  assert_equal c.nick("WiZ"), "NICK WiZ\r\n"
end
  
test "#user" do |c|
  user = c.user "guest", "Ronnie Reagan", false
  assert_equal user, "USER guest 0 * :Ronnie Reagan\r\n"

  user = c.user "guest", "Ronnie Reagan"
  assert_equal user, "USER guest 8 * :Ronnie Reagan\r\n"
end
  
test "#oper" do |c|
  assert_equal c.oper("x", "y"), "OPER x y\r\n"
end
  
test "#mode" do |c|
  mode = c.mode "nickname", :a
  assert_equal mode, "MODE nickname +a\r\n"

  mode = c.mode "nickname", [:a, :i]
  assert_equal mode, "MODE nickname +ai\r\n"

  mode = c.mode "#channel", :b, "*!*@*"
  assert_equal mode, "MODE #channel +b *!*@*\r\n"

  mode = c.mode "#channel", [:b, -:i], ["*!*@*"]
  assert_equal mode, "MODE #channel +b-i *!*@*\r\n"

  mode = c.mode "#channel", [:o, :o, :o, :o], ["a", "b", "c", "d"]
  assert_equal mode, "MODE #channel +ooo a b c\r\nMODE #channel +o d\r\n"
end

test "#service" do |c|
  service = c.service "dict", "French Dictionary", "*.fr"
  assert_equal service, "SERVICE dict * *.fr 0 0 :French Dictionary\r\n"
end

test "#quit" do |c|
  assert_equal c.quit, "QUIT\r\n"
  assert_equal c.quit("Gone"), "QUIT :Gone\r\n"
end
  
test "#squit" do |c|
  squit = c.squit "tolsun.oulu.fi", "Bad Link"
  assert_equal squit, "SQUIT tolsun.oulu.fi :Bad Link\r\n"
end

# Channel operations

test "#join" do |c|
  assert_equal c.join("#foobar"), "JOIN #foobar\r\n"
  assert_equal c.join("&foo", "bar"), "JOIN &foo bar\r\n"

  join = c.join ["#foo" , "&bar", "!baz", "#foo", "&bar", "!baz"] 
  assert_equal join, "JOIN #foo,&bar,!baz,#foo,&bar\r\nJOIN !baz\r\n"

  join = c.join ["#foo" , "&bar", "!baz", "#foo", "&bar", "!baz"], ["bar"]
  assert_equal join, "JOIN #foo,&bar,!baz,#foo,&bar bar\r\nJOIN !baz\r\n"
end

test "#part" do |c|
  assert_equal c.part("#foobar"), "PART #foobar :\r\n"
  assert_equal c.part(["#foo", "&bar"]), "PART #foo,&bar :\r\n"
  assert_equal c.part("#foobar", "Bye"), "PART #foobar :Bye\r\n"
  assert_equal c.part(["#foo", "&bar"], "Bye"), "PART #foo,&bar :Bye\r\n"
end

test "#topic" do |c|
  assert_equal c.topic("#test"), "TOPIC #test\r\n"
  assert_equal c.topic("#test", "topic"), "TOPIC #test :topic\r\n"
  assert_equal c.topic("#test", ""), "TOPIC #test :\r\n"
end
  
test "#names" do |c|
  assert_equal c.names("#x"), "NAMES #x\r\n"
  assert_equal c.names(["#x", "#42"]), "NAMES #x,#42\r\n"
  assert_equal c.names("#x", "irc.org"), "NAMES #x irc.org\r\n"
  assert_equal c.names(["#x", "#42"], "irc.org"), "NAMES #x,#42 irc.org\r\n"
end
  
test "#list" do |c|
  assert_equal c.list("#x") , "LIST #x\r\n"
  assert_equal c.list(["#x", "#42"]), "LIST #x,#42\r\n"
  assert_equal c.list("#x", "irc.org"), "LIST #x irc.org\r\n"
  assert_equal c.list(["#x", "#42"], "irc.org"), "LIST #x,#42 irc.org\r\n"
end

test "#invite" do |c|
  assert_equal c.invite("Wiz", "#x"), "INVITE Wiz #x\r\n"
end

test "#kick" do |c|
  assert_equal c.kick("#x", "John"), "KICK #x John\r\n"
  assert_equal c.kick("#x", "John", "reason"), "KICK #x John :reason\r\n"
end

# Sending Messages

test "#privmsg" do |c|
  message = c.privmsg "jto@tolsun.oulu.fi", "Hello !"
  assert_equal message, "PRIVMSG jto@tolsun.oulu.fi :Hello !\r\n"

  message = c.privmsg "jto@tolsun.oulu.fi", "." * 600
  assert_equal message, "PRIVMSG jto@tolsun.oulu.fi :#{"." * 480}\r\n" \
    "PRIVMSG jto@tolsun.oulu.fi :#{"." * 120}\r\n"
end

test "#notice" do |c|
  message = c.notice "jto@tolsun.oulu.fi", "Hello !"
  assert_equal message, "NOTICE jto@tolsun.oulu.fi :Hello !\r\n"

  message = c.notice "jto@tolsun.oulu.fi", "." * 600
  assert_equal message, "NOTICE jto@tolsun.oulu.fi :#{"." * 481}\r\n" \
    "NOTICE jto@tolsun.oulu.fi :#{"." * 119}\r\n"
end

# Server queries and cs

test "#motd" do |c|
  assert_equal c.motd, "MOTD\r\n"
  assert_equal c.motd("tolsun.oulu.fi"), "MOTD tolsun.oulu.fi\r\n"
end

test "#lusers" do |c|
  assert_equal c.lusers, "LUSERS\r\n"
  assert_equal c.lusers("*.oulu.fi"), "LUSERS *.oulu.fi\r\n"
  assert_equal c.lusers("*.oulu.fi", "x.com"), "LUSERS *.oulu.fi x.com\r\n"
end

test "#version" do |c|
  assert_equal c.version, "VERSION\r\n"
  assert_equal c.version("tolsun.oulu.fi"), "VERSION tolsun.oulu.fi\r\n"
end
  
test "#stats" do |c|
  assert_equal c.stats, "STATS\r\n"
  assert_equal c.stats("m"), "STATS m\r\n"
  assert_equal c.stats("m", "x.com"), "STATS m x.com\r\n"
end

test "#links" do |c|
  assert_equal c.links, "LINKS\r\n"
  assert_equal c.links("*.au"), "LINKS *.au\r\n"
  assert_equal c.links("*.bu.edu", "*.edu"), "LINKS *.edu *.bu.edu\r\n"
end

test "#time" do |c|
  assert_equal c.time, "TIME\r\n"
  assert_equal c.time("*.edu"), "TIME *.edu\r\n"
end

test "#connect" do |c|
  assert_equal c.connect("x.co", 6667), "CONNECT x.co 6667\r\n"
  assert_equal c.connect("x.co", 6667, "x.co"), "CONNECT x.co 6667 x.co\r\n"
end
  
test "#trace" do |c|
  assert_equal c.trace, "TRACE\r\n"
  assert_equal c.trace("*.oulu.fi"), "TRACE *.oulu.fi\r\n"
end
  
test "#admin" do |c|
  assert_equal c.admin, "ADMIN\r\n"
  assert_equal c.admin("syrk"), "ADMIN syrk\r\n"
end
  
test "#info" do |c|
  assert_equal c.info, "INFO\r\n"
  assert_equal c.info("Angel"), "INFO Angel\r\n"
end

# Service query and commands

test "#servlist" do |c|
  assert_equal c.servlist, "SERVLIST\r\n"
  assert_equal c.servlist("*.edu"), "SERVLIST *.edu\r\n"
  assert_equal c.servlist("*.edu", "x"), "SERVLIST *.edu x\r\n"
end
  
test "#squery" do |c|
  squery = c.squery "irchelp", "HELP privmsg"
  assert_equal squery, "SQUERY irchelp :HELP privmsg\r\n"
end

# User based queries

test "#who" do |c|
  assert_equal c.who, "WHO\r\n"
  assert_equal c.who("*.fi"), "WHO *.fi\r\n"
  assert_equal c.who("*.fi", true), "WHO *.fi o\r\n"
end

test "#whois" do |c|
  assert_equal c.whois("wiz"), "WHOIS wiz\r\n"
  assert_equal c.whois(["wiz", "trillian"]), "WHOIS wiz,trillian\r\n"
  assert_equal c.whois("wiz", "eff.org"), "WHOIS eff.org wiz\r\n"

  whois = c.whois ["wiz", "trillian"], "eff.org"
  assert_equal whois, "WHOIS eff.org wiz,trillian\r\n"
end

test "#whowas" do |c|
  assert_equal c.whowas("wiz"), "WHOWAS wiz\r\n"
  assert_equal c.whowas(["wiz", "trillian"]), "WHOWAS wiz,trillian\r\n"
  assert_equal c.whowas("wiz", 2), "WHOWAS wiz 2\r\n"
  assert_equal c.whowas(["wiz", "trillian"], 2), "WHOWAS wiz,trillian 2\r\n"
  assert_equal c.whowas("wiz", 2, "*.edu"), "WHOWAS wiz 2 *.edu\r\n"

  whowas = c.whowas(["wiz", "trillian"], 2, "*.edu")
  assert_equal whowas, "WHOWAS wiz,trillian 2 *.edu\r\n"
end

# Miscellaneous messages

test "#kill" do |c|
  assert_equal c.kill("nickname", "reason"), "KILL nickname :reason\r\n"
end
  
test "#ping" do |c|
  assert_equal c.ping("tolsun.oulu.fi"), "PING tolsun.oulu.fi\r\n"
  assert_equal c.ping("WiZ", "tolsun.oulu.fi"), "PING WiZ tolsun.oulu.fi\r\n"
end
  
test "#pong" do |c|
  assert_equal c.pong("csd.bu.edu"), "PONG csd.bu.edu\r\n"
  assert_equal c.pong("csd.bu.edu", "x.com"), "PONG csd.bu.edu x.com\r\n"
end

test "#error" do |c|
  assert_equal c.error("msg"), "ERROR :msg\r\n"
end

# Optional features

test "#away" do |c|
  assert_equal c.away, "AWAY\r\n"
  assert_equal c.away("Getting the pizza"), "AWAY :Getting the pizza\r\n"
end

test "#rehash" do |c|
  assert_equal c.rehash, "REHASH\r\n"
end

test "#die" do |c|
  assert_equal c.die, "DIE\r\n"
end

test "#restart" do |c|
  assert_equal c.restart, "RESTART\r\n"
end
  
test "#summon" do |c|
  assert_equal c.summon("jto"), "SUMMON jto\r\n"
  assert_equal c.summon("jto", "x.com"), "SUMMON jto x.com\r\n"
  assert_equal c.summon("jto", "x.com", "#test"), "SUMMON jto x.com #test\r\n"
end
  
test "#users" do |c|
  assert_equal c.users, "USERS\r\n"
  assert_equal c.users("eff.org"), "USERS eff.org\r\n"
end

test "#wallops" do |c|
  assert_equal c.wallops("Text to be sent"), "WALLOPS :Text to be sent\r\n"

  message = c.wallops("." * 600)
  assert_equal message, "WALLOPS :#{"." * 499}\r\nWALLOPS :#{"." * 101}\r\n"
end

test "#userhost" do |c|
  assert_equal c.userhost("Wiz"), "USERHOST Wiz\r\n"
  assert_equal c.userhost(["Wiz", "x", "y"]), "USERHOST Wiz x y\r\n"
end
  
test "#ison" do |c|
  assert_equal c.ison("Wiz"), "ISON Wiz\r\n"
  assert_equal c.ison(["Wiz", "x", "y"]), "ISON Wiz x y\r\n"
end
