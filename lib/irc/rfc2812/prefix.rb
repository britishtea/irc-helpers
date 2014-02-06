require "irc/prefix"
require "irc/rfc2812/helpers"

module IRC
  module RFC2812
    class Prefix < IRC::Prefix
      def self.parse(raw_prefix)
        Helpers.parse_prefix raw_prefix
      end

      def valid?
        Helpers.valid_prefix? self.raw
      end
    end
  end
end