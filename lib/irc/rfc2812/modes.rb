module IRC
  module RFC2812
    # Public: Represents a MODE response. Only works for channel modes.
    class Modes
      def initialize(*messages)
        @modes = { :b => [], :e => [], :I => [] }

        messages.each do |message|
          method = "parse_#{message.command}"

          if self.respond_to?(method, true)
            self.send(method, message)
          end
        end
      end

      # Public: Fetches a mode. Note that the mode "l" (limit) returns a String
      # rather than an Integer.
      #
      # mode - A mode Symbol or String.
      #
      #
      # Examples
      #
      #   modes[:n] # => true
      #   modes[:k] # => "password"
      #   modes[:b] # => ["nick!user@host.com"]
      #
      # Returns true/false, a String or an Array of Strings.
      def [](mode)
        @modes.fetch(mode.to_sym, false)
      end

    private

      def parse_324(message)
        modes      = message.params[2].delete("+").chars.map(&:to_sym)
        parameters = message.params[3..-1]

        modes.zip(parameters) do |mode, parameter|
          @modes[mode] = parameter.nil? ? true : parameter
        end
      end

      # Banlist
      def parse_367(message)
        @modes[:b] << message.params[2]
      end

      # Exceptlist
      def parse_348(message)
        @modes[:e] << message.params[2]
      end

      # Invitelist
      def parse_346(message)
        @modes[:I] << message.params[2]
      end
    end
  end
end
