require "irc/message"
require "irc/rfc2812/constants"
require "irc/rfc2812/helpers"

module IRC
  module RFC2812
    class Message < IRC::Message
      include Constants

      def self.parse(raw_message)
        Helpers.parse raw_message
      end
      
      def valid?
        Helpers.valid? self.raw
      end

      # Public: Checks if the message is a numeric reply.
      def numeric?
        self.command =~ /^\d+$/
      end

      # Public: Checks if the message is an error reply according to RFC2812.
      def error?
        self.numeric? && ERROR_REPLY_RANGE.cover?(self.command)
      end

      # Public: Extracts the target channel.
      #
      # Returns a String or nil.
      def target_channel
        name = case self.command
          when :invite              then self.params[1]
          when RPL_NAMREPLY         then self.params[2]
          when ERR_USERNOTINCHANNEL then self.params[2]
          when ERR_USERONCHANNEL    then self.params[2]
          when ERR_UNKNOWNMODE      then self.trail[/\S+$/]
          else                           self.params.fetch(numeric? ? 1 : 0, "")
        end

        if name.start_with?('&', '#', '+', '!')
          return name
        end

        return nil
      end

    private

      # Internal: A range of error reply codes.
      ERROR_REPLY_RANGE = :"400"...:"599"

      def wrap_prefix(prefix)
        Prefix.new(prefix)
      end
    end
  end
end
