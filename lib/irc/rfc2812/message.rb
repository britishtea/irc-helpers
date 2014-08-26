require "irc/message"
require "irc/rfc2812/helpers"

module IRC
  module RFC2812
    class Message < IRC::Message
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

    private

      # Internal: A range of error reply codes.
      ERROR_REPLY_RANGE = :"400"...:"599"
    end
  end
end
