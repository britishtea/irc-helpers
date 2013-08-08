require_relative "../test_helper"
require "irc/rfc2812"

setup do
  Object.new.tap do |obj| 
    obj.extend IRC::RFC2812::Commands
    def obj.raw(message); message; end
  end
end

# Connection registration

test("#pass") { |command| assert_equal command.pass("pass"), "PASS pass" }
  
test("#nick") { |command| assert_equal command.nick("WiZ"), "NICK WiZ" }
  
test "#user" do |command|
  user = command.user "guest", "Ronnie Reagan", false
  assert_equal user, "USER guest 0 * :Ronnie Reagan"

  user = command.user "guest", "Ronnie Reagan"
  assert_equal user, "USER guest 8 * :Ronnie Reagan"
end
  
test("#oper") { |command| assert_equal command.oper("x", "y"), "OPER x y" }
  
test "#mode" do |command|
  mode = command.mode "nickname", :a
  assert_equal mode, "MODE nickname +a"

  mode = command.mode "nickname", [:a, :i]
  assert_equal mode, "MODE nickname +ai"

  mode = command.mode "#channel", :b, "*!*@*"
  assert_equal mode, "MODE #channel +b *!*@*"

  mode = command.mode "#channel", [:b, -:i], ["*!*@*"]
  assert_equal mode, "MODE #channel +b-i *!*@*"

  mode = command.mode "#channel", [:o, :o, :o, :o], ["a", "b", "c", "d"]
  assert_equal mode, ["MODE #channel +ooo a b c", "MODE #channel +o d"]
end

test "#service" do |command|
  service = command.service "dict", "French Dictionary", "*.fr"
  assert_equal service, "SERVICE dict * *.fr 0 0 :French Dictionary"
end

test "#quit" do |command|
  assert_equal command.quit, "QUIT" 
  assert_equal command.quit("Gone"), "QUIT :Gone"
end
  
test "#squit" do |command|
  squit = command.squit "tolsun.oulu.fi", "Bad Link"
  assert_equal squit, "SQUIT tolsun.oulu.fi :Bad Link"
end

# Channel operations

test "#join" do |command|
  assert_equal command.join("#foobar"), ["JOIN #foobar"]
  assert_equal command.join("&foo", "bar"), ["JOIN &foo bar"]

  join = command.join ["#foo" , "&bar", "!baz", "#foo", "&bar", "!baz"] 
  assert_equal join, ["JOIN #foo,&bar,!baz,#foo,&bar", "JOIN !baz"]

  join = command.join ["#foo" , "&bar", "!baz", "#foo", "&bar", "!baz"], ["bar"]
  assert_equal join, ["JOIN #foo,&bar,!baz,#foo,&bar bar", "JOIN !baz"]
end

test "#part" do |command|
  assert_equal command.part("#foobar"), "PART #foobar :"
  assert_equal command.part(["#foo", "&bar"]), "PART #foo,&bar :"
  assert_equal command.part("#foobar", "Bye"), "PART #foobar :Bye"
  assert_equal command.part(["#foo", "&bar"], "Bye"), "PART #foo,&bar :Bye"
end

test "#topic" do |command|
  assert_equal command.topic("#test"), "TOPIC #test"
  assert_equal command.topic("#test", "topic"), "TOPIC #test :topic"
  assert_equal command.topic("#test", ""), "TOPIC #test :"
end
  
test "#names" do |command|
  assert_equal command.names("#x"), "NAMES #x"
  assert_equal command.names(["#x", "#42"]), "NAMES #x,#42"
  assert_equal command.names("#x", "irc.org"), "NAMES #x irc.org"
  assert_equal command.names(["#x", "#42"], "irc.org"), "NAMES #x,#42 irc.org"
end
  
test "#list" do |command|
  assert_equal command.list("#x") , "LIST #x"
  assert_equal command.list(["#x", "#42"]), "LIST #x,#42"
  assert_equal command.list("#x", "irc.org"), "LIST #x irc.org"
  assert_equal command.list(["#x", "#42"], "irc.org"), "LIST #x,#42 irc.org"
end

test "#invite" do |command|
  assert_equal command.invite("Wiz", "#x"), "INVITE Wiz #x"
end

test "#kick" do |command|
  assert_equal command.kick("#x", "John"), "KICK #x John"
  assert_equal command.kick("#x", "John", "reason"), "KICK #x John :reason"
end

# Sending Messages

test "#privmsg" do |command|
  message = command.privmsg "jto@tolsun.oulu.fi", "Hello !"
  assert_equal message, "PRIVMSG jto@tolsun.oulu.fi :Hello !"
end

test "#notice" do |command|
  message = command.notice "jto@tolsun.oulu.fi", "Hello !"
  assert_equal message, "NOTICE jto@tolsun.oulu.fi :Hello !"
end

# Server queries and commands

test "#motd" do |command|
  assert_equal command.motd, "MOTD"
  assert_equal command.motd("tolsun.oulu.fi"), "MOTD tolsun.oulu.fi"
end

test "#lusers" do |command|
  assert_equal command.lusers, "LUSERS"
  assert_equal command.lusers("*.oulu.fi"), "LUSERS *.oulu.fi"
  assert_equal command.lusers("*.oulu.fi", "x.com"), "LUSERS *.oulu.fi x.com"
end

test "#version" do |command|
  assert_equal command.version, "VERSION"
  assert_equal command.version("tolsun.oulu.fi"), "VERSION tolsun.oulu.fi"
end
  
test "#stats" do |command|
  assert_equal command.stats, "STATS"
  assert_equal command.stats("m"), "STATS m"
  assert_equal command.stats("m", "x.com"), "STATS m x.com"
end

test "#links" do |command|
  assert_equal command.links, "LINKS"
  assert_equal command.links("*.au"), "LINKS *.au"
  assert_equal command.links("*.bu.edu", "*.edu"), "LINKS *.edu *.bu.edu"
end

test "#time" do |command|
  assert_equal command.time, "TIME"
  assert_equal command.time("*.edu"), "TIME *.edu"
end

test "#connect" do |command|
  assert_equal command.connect("x.co", 6667), "CONNECT x.co 6667"
  assert_equal command.connect("x.co", 6667, "x.co"), "CONNECT x.co 6667 x.co"
end
  
test "#trace" do |command|
  assert_equal command.trace, "TRACE"
  assert_equal command.trace("*.oulu.fi"), "TRACE *.oulu.fi"
end
  
test "#admin" do |command|
  assert_equal command.admin, "ADMIN"
  assert_equal command.admin("syrk"), "ADMIN syrk"
end
  
test "#info" do |command|
  assert_equal command.info, "INFO"
  assert_equal command.info("Angel"), "INFO Angel"
end

# Service query and commands

test "#servlist" do |command|
  assert_equal command.servlist, "SERVLIST"
  assert_equal command.servlist("*.edu"), "SERVLIST *.edu"
  assert_equal command.servlist("*.edu", "x"), "SERVLIST *.edu x"
end
  
test "#squery" do |command|
  squery = command.squery "irchelp", "HELP privmsg"
  assert_equal squery, "SQUERY irchelp :HELP privmsg"
end

# User based queries

test "#who" do |command|
  assert_equal command.who, "WHO"
  assert_equal command.who("*.fi"), "WHO *.fi"
  assert_equal command.who("*.fi", true), "WHO *.fi o"
end

test "#whois" do |command|
  assert_equal command.whois("wiz"), "WHOIS wiz"
  assert_equal command.whois(["wiz", "trillian"]), "WHOIS wiz,trillian"
  assert_equal command.whois("wiz", "eff.org"), "WHOIS eff.org wiz"

  whois = command.whois ["wiz", "trillian"], "eff.org"
  assert_equal whois, "WHOIS eff.org wiz,trillian"
end

test "#whowas" do |command|
  assert_equal command.whowas("wiz"), "WHOWAS wiz"
  assert_equal command.whowas(["wiz", "trillian"]), "WHOWAS wiz,trillian"
  assert_equal command.whowas("wiz", 2), "WHOWAS wiz 2"
  assert_equal command.whowas(["wiz", "trillian"], 2), "WHOWAS wiz,trillian 2"
  assert_equal command.whowas("wiz", 2, "*.edu"), "WHOWAS wiz 2 *.edu"

  whowas = command.whowas(["wiz", "trillian"], 2, "*.edu")
  assert_equal whowas, "WHOWAS wiz,trillian 2 *.edu"
end

# Miscellaneous messages

test "#kill" do |command|
  assert_equal command.kill("nickname", "reason"), "KILL nickname :reason"
end
  
test "#ping" do |command|
  assert_equal command.ping("tolsun.oulu.fi"), "PING tolsun.oulu.fi"
  assert_equal command.ping("WiZ", "tolsun.oulu.fi"), "PING WiZ tolsun.oulu.fi"
end
  
test "#pong" do |command|
  assert_equal command.pong("csd.bu.edu"), "PONG csd.bu.edu"
  assert_equal command.pong("csd.bu.edu", "x.com"), "PONG csd.bu.edu x.com"
end

test("#error") { |command| assert_equal command.error("msg"), "ERROR :msg" }

# Optional features

test "#away" do |command|
  assert_equal command.away, "AWAY"
  assert_equal command.away("Getting the pizza"), "AWAY :Getting the pizza"
end

test("#rehash") { |command| assert_equal command.rehash, "REHASH" }

test("#die") { |command| assert_equal command.die, "DIE" }

test("#restart") { |command| assert_equal command.restart, "RESTART" }
  
test "#summon" do |command|
  assert_equal command.summon("jto"), "SUMMON jto"
  assert_equal command.summon("jto", "x.com"), "SUMMON jto x.com"
  assert_equal command.summon("jto", "x.com", "#test"), "SUMMON jto x.com #test"
end
  
test "#users" do |command|
  assert_equal command.users, "USERS"
  assert_equal command.users("eff.org"), "USERS eff.org"
end

test "#wallops" do |command|
  assert_equal command.wallops("Text to be sent"), "WALLOPS :Text to be sent"
end

test "#userhost" do |command|
  assert_equal command.userhost("Wiz"), "USERHOST Wiz"
  assert_equal command.userhost(["Wiz", "x", "y"]), "USERHOST Wiz x y"
end
  
test "#ison" do |command|
  assert_equal command.ison("Wiz"), "ISON Wiz"
  assert_equal command.ison(["Wiz", "x", "y"]), "ISON Wiz x y"
end
