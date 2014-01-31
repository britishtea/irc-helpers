module IRC
  module RFC2812
    module Helpers
      module_function

      # Each IRC message may consist of up to three main parts: the prefix
      # (OPTIONAL), the command, and the command parameters (maximum of
      # fifteen (15)).  The prefix, command, and all parameters are separated
      # by one ASCII space character (0x20) each.

      # The presence of a prefix is indicated with a single leading ASCII
      # colon character (':', 0x3b), which MUST be the first character of the
      # message itself.  There MUST be NO gap (whitespace) between the colon
      # and the prefix.  The prefix is used by servers to indicate the true
      # origin of the message.  If the prefix is missing from the message, it
      # is assumed to have originated from the connection from which it was
      # received from.

      # The command MUST either be a valid IRC command or a three (3) digit
      # number represented in ASCII text.

      # IRC messages are always lines of characters terminated with a CR-LF
      # (Carriage Return - Line Feed) pair, and these messages SHALL NOT
      # exceed 512 characters in length, counting all characters including
      # the trailing CR-LF. Thus, there are 510 characters maximum allowed
      # for the command and its parameters.  There is no provision for
      # continuation of message lines.  See section 6 for more details about
      # current implementations.

      # Public: Parses an IRC message.
      #
      # message - A message String.
      #
      # Return an Array of form ["prefix", "command", ["param", "param"]].
      def parse(message)
        if message.start_with? ":"
          prefix, command, parameters = message[1..-1].strip.split(" ", 3)
        else
          command, parameters = message.strip.split(" ", 2)
        end

        if parameters.nil?
          parameters = []
        elsif parameters.start_with? ":"
          parameters = [parameters[1..-1]]
        else
          parameters, trailing = parameters.split(" :", 2)
          parameters = parameters.split(" ") << trailing
        end

        return [prefix, command, parameters.compact]
      end

      # Public: Parses an IRC prefix.
      #
      # prefix - A prefix String.
      #
      # Returns an Array of form ["nick", "user", "host.com"].
      def parse_prefix(prefix)
        nick_and_user, host = String(prefix).split "@", 2

        if host.nil?
          if nick_and_user.include? "."
            servername = nick_and_user
          else
            nickname = nick_and_user
          end
        else
          nickname, user = nick_and_user.split "!", 2
        end

        [nickname, user, host || servername]
      end

      # Public: Checks if a String is a valid IRC message according to Section
      # 2.3 of RFC 2812. Note that not all constraints are checked, yet.
      #
      # message - A message String.
      #
      # Returns a Boolean (true or false).
      def valid?(message)
        prefix, command, parameters = parse message
        
        # Maximum of fifteen command parameters
        return false if parameters.length > 15

        # There MUST be NO whitespace between the colon and the prefix.
        return false if message =~ /^:\s/

        # The command MUST either be a valid IRC command or a three digit number 
        # represented in ASCII text.
        return false unless command =~ /^([A-Z]+|\d{3})$/

        # IRC messages are always lines of characters terminated with a CR-LF 
        # (Carriage Return - Line Feed)
        return false unless message.end_with? "\r\n"
        
        # Messages SHALL NOT exceed 512 characters in length, counting all 
        # characters including the trailing CR-LF.
        return false if message.length > 512
        
        # NUL (%x00) is not allowed within messages.
        return false if message.include? "\x00"

        # Hostnames can not be longer than 63 characters.
        hostname = prefix.split("@")[1] || (prefix if prefix.include? ".") || ""
        return false if hostname.length > 63

        return true
      end

      # Public: Checks if a String is a valid IRC prefix according to Section 
      # 2.3 of RFC 2812. Note that not all constraints are checked, yet.
      #
      # prefix - A prefix String.
      #
      # Returns a Boolean (true or false).
      def valid_prefix?(prefix)
        return false if prefix.count("@") > 1
        return false if prefix.count("!") > 1

        nick, user, host = parse_prefix prefix

        # Hostnames can not be longer than 63 characters.
        return false if String(host).length > 63

        # User can not contain ["\x00", "\r", "\n", " ", "@"]
        return false if ["\x00", "\r", "\n", " ", "@"].any? do |char|
          String(user).include? char
        end

        # Nick can not contain characters other than A-Z, a-z, 0-9, "[", "]", 
        # "\", "`", "_", "^", "{", "|" or "}"
        return false if nick && nick !~ /^[\w\[\]\\`\^\{\|\}]+$/

        return true
      end
    end
  end
end
