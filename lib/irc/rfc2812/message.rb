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
    end
  end
end
