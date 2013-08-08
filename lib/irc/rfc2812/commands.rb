module IRC
  module RFC2812
    # Public: Implements all IRC commands that can be sent as described in RFC
    # 2812: Internet Relay Chat Protocol (https://tools.ietf.org/html/rfc2812).
    # The module only concerns itself with *sending* commands.
    #
    # Examples
    # 
    #   class Connection
    #     include Banter::IRC::Commands
    #     
    #     # Some methods that set up a socket and whatnot.
    #     
    #     def raw(message)
    #       @socket.write "message\r\n"
    #     end
    #   end
    #
    #   x = Connection.new
    #   x.join '#channel'
    module Commands
      # Connection Registration Commands.

      # Public: Sends a PASS command. The PASS command is used to set a
      # 'connection password'.
      #
      # password - The server password String.
      def pass(password)
        raw "PASS #{password}"
      end

      # Public: Sends a NICK command. The NICK command is used to give a user a
      # nickname or change the current one.
      #
      # nickname - The desired nickname String.
      def nick(nickname)
        raw "NICK #{String(nickname)}"
      end

      # Public: Sends a USER command. The USER command is used at the beginning of
      # connection to specify the username, hostname and realname of a new user.
      #
      # username  - The username String.
      # realname  - The real name String.
      # invisible - A Boolean that asks for the user mode 'i' (default: true).
      def user(username, realname, invisible = true)
        raw "USER #{username} #{invisible ? 8 : 0} * :#{realname}"
      end

      # Public: Sends an OPER command. The OPER command is used by a normal user
      # to obtain operator privileges.
      #
      # user     - The username String.
      # password - The password String.
      def oper(user, password)
        raw "OPER #{user} #{password}"
      end

      # Public: Sends a MODE command. This either requests the modes (when the
      # modes parameter is empty) or changes the modes (when it's not).
      #
      # target  - The channel name String or nickname String.
      # modes   - A mode Symbol or an Array of mode Symbols (default: []).
      # options - A parameter String or an Array or parameter Strings (default:
      #           []).
      #
      # Examples
      # 
      #   # User modes messages:
      #   mode 'nickname'
      #   mode 'nickname', [:a, -:i] # -:i translates to :"-i"
      #
      #   # Channel mode messages:
      #   mode '#channel'
      #   mode '#channel', :b, '*!*@*'
      #   mode '#channel', [+:b, :i, :m], '*!*@*'
      def mode(target, modes = [], parameters = [])
        if modes.size > 3
          (modes.size / 3 + 1).times.map do
            mode target, modes.shift(3), parameters.shift(3)
          end
        else
          parameters = Array(parameters)
          modes      = Array(modes).map! { |m| m.to_s.start_with?('-') ? m : +m }
          groups     = modes.group_by { |m| m[0] }
          pos, neg   = Array(groups['+']), Array(groups['-'])

          mode_string = String.new
          mode_string << "+#{pos.map { |m| m[1] }.join}" unless pos.empty?
          mode_string << "-#{neg.map { |m| m[1] }.join}" unless neg.empty?

          raw "MODE #{String(target)} #{mode_string} #{parameters.join ' '}".strip
        end
      end

      # Public: Sends a SERVICE command. The SERVICE command is used to register
      # a new service.
      #
      # nickname     - A nickname String.
      # info         - An info String.
      # distribution - A String servers have to match against.
      def service(nickname, info, distribution = '*')
        raw "SERVICE #{String(nickname)} * #{distribution} 0 0 :#{info}"
      end

      # Public: Sends a QUIT command.
      #
      # message - The quit message String (default: nil).
      def quit(message = nil)
        raw message.nil? ? "QUIT" : "QUIT :#{message}"
      end

      # Public: Sends a SQUIT command. The SQUIT command is used to disconnect
      # server links (only available to IRC operators).
      #
      # server  - A server name String.
      # comment - A comment String.
      def squit(server, comment)
        raw "SQUIT #{server} :#{comment}"
      end

      # Channel Operation Commands

      # Public: Sends a JOIN command (joins a channel). The JOIN command is used
      # by a user to request to start listening to the specific channel. Note
      # that this method doesn't automatically add #s, &s, +s or !s.
      #
      # channel - The channel name String or an Array of them.
      # key     - The key for the channel as a String (default: nil).
      #
      # Examples
      # 
      #   join '#foo'
      #   join '#foo', 'key'
      #   join ['#foo', #bar], ['key_for_#foo']
      def join(channel, key = nil)
        channel = Array(channel).each_slice(5).to_a
        key     = Array(key).each_slice(5).to_a
        
        channel.zip(key).map do |channels,keys|
          channels.map! { |chan| String(chan) }

          raw "JOIN #{channels.join ','} #{Array(keys).join ','}".strip
        end
      end

      # Public: Sends a PART command (leaves a channel).
      #
      # channels - The channel name String or an Array of channel name Strings.
      # message  - A part message String (default: nil).
      def part(channels, message = nil)
        channels = Array(channels).map { |chan| String(chan) }.join ','

        raw "PART #{channels} :#{message}"
      end

      # Public: Sends a TOPIC command.
      #
      # channel - The channel name String.
      # topic   - The new topic String (default: nil).
      #
      # Examples
      # 
      #   topic '#ruby' 
      #   topic '#ruby', 'welcome to #ruby!'
      def topic(channel, topic = nil)
        channel = String(channel)

        raw topic.nil? ? "TOPIC #{channel}" : "TOPIC #{channel} :#{topic}"
      end

      # Public: Sends a NAMES command. Requests all nicknames that are visible
      # on any channel that isn't private (+p) or secret (+s), unless they're
      # joined.
      #
      # channels - The channel name String or an Array of channel name Strings
      #           (default: nil)
      # target   - The target (server name) String (default: nil).
      #
      # Examples
      # 
      #   names # => requests a list of all visible channels and users
      #   names '#ruby' # => requests a list off all visible users on #ruby
      #
      # Returns an Array of IRC::Messages or nil.
      def names(channels = nil, target = nil)
        channels = Array(channels).map { |chan| String(chan) }.join ','

        raw "NAMES #{channels} #{target}".strip
      end

      # Public: Sends a LIST command. Lists channels and their topics.
      #
      # channels - The channel name String or an Array of channel name Strings
      #           (default: nil).
      # target   - The target (server name) String (default: nil).
      #
      # Examples
      # 
      #   list # => requests to list all channels
      #   list ['#ruby', '#rails'] # requests to list channels #ruby and #rails
      def list(channels = nil, target = nil)
        channels = Array(channels).map { |chan| String(chan) }.join ','

        raw "LIST #{channels} #{target}".strip
      end

      # Public: Sends an INVITE command.
      #
      # nickname - The nickname String of the user that should be invited.
      # channel  - The channel name String.
      def invite(nickname, channel)
        raw "INVITE #{String(nickname)} #{String(channel)}"
      end

      # Public: Sends a KICK command.
      #
      # channel - The channel name String.
      # user    - The nickname String.
      # comment - The kick message String (default: nil).
      def kick(channel, user, comment = nil)
        if comment.nil?
          raw "KICK #{String(channel)} #{String(user)}"
        else
          raw "KICK #{String(channel)} #{String(user)} :#{comment}"
        end
      end

      # Sending Messages

      # Public: Sends a PRIVMSG command. The PRIVMSG command is used to send
      # private messages between users, as well as to send messages to channels.
      #
      # receiver - The nickname, channel name, host mask, server mask String.
      # message  - The message String.
      def privmsg(receiver, message)
        raw "PRIVMSG #{String(receiver)} :#{message}"
      end

      # Public: Sends a NOTICE command.
      #
      # receiver - The nickname, channel name, host mask or server mask String.
      # message  - The message String.
      def notice(receiver, message)
        raw "NOTICE #{String(receiver)} :#{message}"
      end

      # Server Queries

      # Public: Sends a MOTD command. The MOTD command is used to get the
      # "Message Of The Day" of a server.
      #
      # target - A server name String (default: nil).
      def motd(target = nil)
        raw "MOTD #{target}".strip
      end

      # Public: Sends a LUSERS command. The LUSERS command is used to get
      # statistics about the size of the IRC network.
      #
      # mask   - A mask String (default: nil).
      # target - A target String (default: nil).
      def lusers(mask = nil, target = nil)
        raw "LUSERS #{String(mask)} #{target}".strip
      end

      # Public: Sends a VERSION command. The VERSION command is used to query
      # the version of the server program.
      #
      # target - A server name String (default: nil).
      def version(target = nil)
        raw "VERSION #{target}".strip
      end

      # Public: Sends a STATS command. The STATS command is used to query
      # statistics of certain server.
      #
      # query  - A single character query Symbol (default: nil).
      # target - A server name String (default: nil).
      def stats(query = nil, target = nil)
        raw "STATS #{query} #{target}".strip
      end

      # Public: Sends a LINKS command. The LINKS command is used to list all
      # servernames, which are known by the server answering the query.
      #
      # mask   - A host mask String (default: nil).
      # remote - A remote server name String (default: nil).
      def links(mask = nil, remote = nil)
        if remote.nil?
          raw "LINKS #{String(mask)}".strip
        else
          "LINKS #{remote} #{String(mask)}".strip
        end
      end

      # Public: Sends a TIME command. The time command is used to query local
      # time from the specified server.
      #
      # target - A target (server name) String (default: nil).
      def time(target = nil)
        raw "TIME #{target}".strip
      end

      # Public: Sends a CONNECT command. The CONNECT command can be used to
      # request a server to try to establish a new connection to another server
      # immediately.
      #
      # target - A target (server name) String.
      # port   - A port number Integer (default: 6667).
      # remote - A remote (server name) String (default: nil).
      def connect(target, port = 6667, remote = nil)
        raw "CONNECT #{target} #{port} #{remote}".strip
      end

      # Public: Sends a TRACE command. The TRACE command is used to find the 
      # route to specific server and information about its peers.
      #
      # target - A target (server name) String (default: nil).
      def trace(target = nil)
        raw "TRACE #{target}".strip
      end
      
      # Public: Sends an ADMIN command. The ADMIN command is used to find
      # information about the administrator of the given server, or current
      # server if target parameter is omitted.
      #
      # target - A target (server name) String (default: nil).
      def admin(target = nil)
        raw "ADMIN #{target}".strip
      end
      
      # Public: Sends an INFO command. The INFO command is REQUIRED to return
      # information describing the server.
      #
      # target - A target (server name) String (default: nil).
      def info(target = nil)
        raw "INFO #{target}".strip
      end
      

      # Service Queries and Commands

      # Pubic: Sends a SERVLIST command. The SERVLIST command is used to list
      # services currently connected to the network and visible to the user
      # issuing the command.
      #
      # mask   - A mask String (default: nil).
      # target - A type String (default: nil).
      def servlist(mask = nil, type = nil)
        raw "SERVLIST #{String(mask)} #{type}".strip
      end
      
      # Public: Sends a SQUERY command. The SQUERY command is used similarly
      # to PRIVMSG. The only difference is that the recipient MUST be a service.
      #
      # servicename - A service name String.
      # text        - A text String.
      def squery(servicename, text)
        raw "SQUERY #{servicename} :#{text}"
      end

      # User Based Queries

      # Public: Sends a WHO command. The WHO command is used by a client to
      # generate a query which returns a list of information which 'matches' the
      # <mask> parameter given by the client.
      #
      # name           - The nickname, channel name, host mask, server mask
      #                  String or an Array of such Strings.
      # operaters_only - A Boolean (default: false).
      #
      # Examples
      # 
      #   who
      #   who '*.fi'
      #   who '*.fi', true
      def who(name = nil, operators_only = false)
        raw "WHO #{String(name)} #{"o" if operators_only}".strip
      end

      # Public: Sends a WHOIS command. The WHOIS command is used to query
      # information about particular user.
      #
      # nickmask - The nickname String.
      # server   - A servername String (default: nil).
      #
      # Examples
      # 
      #   whois 'Alfredo'
      #   whois 'Alfredo', 'gibson.freenode.net'
      def whois(masks, server = nil)
        masks = Array(masks).map { |mask| String(mask) }.join ','

        raw server.nil? ? "WHOIS #{masks}" : "WHOIS #{server} #{masks}"
      end

      # Public: Sends a WHOWAS command. The WHOWAS command requests information
      # about a nickname which no longer exists.
      #
      # nicknames - The nickname String or an Array of nickname Strings.
      # count     - The maximum amount of entries as Integer (default: nil).
      # target    - The server String (default: nil).
      #
      # Examples
      # 
      #   whowas 'Alfredo', 8
      #   whowas ['Alfredo', 'Angel'], 2
      def whowas(nicknames, count = nil, target = nil)
        nicknames = Array(nicknames).map { |mask| String(mask) }.join ','

        raw "WHOWAS #{nicknames} #{count} #{target}".strip
      end

      # Miscellaneous messages

      # Public: Sends a KILL command. The KILL command is used to cause a
      # client-server connection to be closed by the server which has the actual
      # connection.
      #
      # nickname - A nickname String.
      # comment  - A comment String (the reason for the kill).
      def kill(nickname, comment)
        raw "KILL #{String(nickname)} :#{comment}"
      end

      # Public: Sends a PING command.
      #
      # server  - The name String of the server.
      # forward - The name String of the server the PING message should be
      #           forwarded to (default: nil).
      def ping(server, forward = nil)
        raw "PING #{server} #{forward}".strip
      end

      # Public: Sends a PONG command. The PONG command is a reply to a PING
      # command.
      #
      # deamon  - The name String of the server.
      # deamon2 - The name String of the server the PONG message should be
      #           forwarded to (default: nil).
      def pong(server, forward = nil)
        raw "PONG #{server} #{forward}".strip
      end

      # Public: Sends an ERROR command. The ERROR command is for use by servers
      # when reporting a serious or fatal error to its peers.
      #
      # message - A message String.
      def error(message)
        raw "ERROR :#{message}"
      end

      # Optional features

      # Public: Sends an AWAY command. With the AWAY command, clients can set an
      # automatic reply string for any PRIVMSG commands directed at them (not to
      # a channel they are on).
      #
      # text - A message String (default: nil).
      def away(text = nil)
        raw text.nil? ? "AWAY" : "AWAY :#{text}"
      end

      # Public: Sends a REHASH command. The REHASH command is an administrative
      # command which can be used by an operator to force the server to re-read
      # and process its configuration file.
      def rehash
        raw 'REHASH'
      end

      # Public: Sends a DIE command. An operator can use the DIE command to
      # shutdown the server.
      def die
        raw 'DIE'
      end

      # Public: Sends a RESTART command. An operator can use the RESTART command
      # to force the server to restart itself.
      def restart
        raw 'RESTART'
      end
      
      # Public: Sends a SUMMON command. The SUMMON command can be used to give
      # users who are on a host running an IRC server a message asking them to
      # please join IRC.
      #
      # user    - A user name String.
      # target  - A target (server name) String (default: nil).
      # channel - A channel name String (default: nil).
      def summon(user, target = nil, channel = nil)
        raw "SUMMON #{String(user)} #{target} #{String(channel)}".strip
      end
      
      # Public: Sends a USERS command. The USERS command returns a list of users
      # logged into the server in a format similar to the UNIX commands who(1),
      # rusers(1) and finger(1).
      #
      # target - A target (server name) String (default: nil).
      def users(target = nil)
        raw "USERS #{target}".strip
      end
      
      # Public: Sends a WALLOPS command. The WALLOPS command is used to send a
      # message to all currently connected users who have set the 'w' user mode
      # for themselves.
      #
      # text - A text String.
      def wallops(text)
        raw "WALLOPS :#{text}"
      end

      # Public: Sends an USERHOST command. The USERHOST command requests a list
      # of information about each nickname that it found.
      #
      # nicknames - A nickname String or an Array of such Strings (max. 5).
      def userhost(nicknames)
        raw "USERHOST #{Array(nicknames).map { |nick| String(nick) }.join ' '}"
      end

      # Public: Sends an ISON command. The ISON command requests wether or not a
      # nickname is currently on IRC.
      #
      # nicknames - A nickname String or an Array of such Strings (max. 5).
      def ison(nicknames)
        raw "ISON #{Array(nicknames).map { |nick| String(nick) }.join ' '}"
      end

      def raw(*args)
        raise NotImplementedError, "#{self.class}#raw not defined."
      end
    end
  end
end

# Syntax sugar for fancy IRC modes (i.e. +:a and -:a).
class Symbol
  def -@
    to_s.start_with?('+', '-') ? :"-#{to_s[1..-1]}" : :"-#{self}"
  end

  def +@
    to_s.start_with?('+', '-') ? :"+#{to_s[1..-1]}" : :"+#{self}"
  end
end
