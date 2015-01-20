module IRC
  module RFC2812
    # Public: Represents a WHOIS response.
    class Whois
      attr_reader :nick, :user, :host, :realname, :channels, :server, 
        :server_info, :seconds_idle

      # Public: Gets the statuses Hash (`{ "#channel" => :status }`). The status
      # is `nil` if there is no status.
      attr_reader :statuses

      # Public: Initializes the ...
      #
      # messages - An Array of IRC::Messages.
      def initialize(*messages)
        @channels = []
        @statuses = {}

        messages.each do |message|
          method = "parse_#{message.command}"
          
          if self.respond_to? method, true
            self.send method, message
          end
        end
      end

      def away?
        @away || false
      end

      # Public: Operator means IRC operator, not channel operator.
      def operator?
        @operator || false
      end

      # Public: Gets the channels. If a `status` is given, it returns only the
      # channels with that status.
      #
      # status - A status Symbol (default: false).
      #
      # Returns an Array.
      def channels(status = false)
        if status == false
          @channels
        elsif status.nil?
          @statuses.select { |_, s| s.nil? }.map(&:first)
        else
          @statuses.select { |_, s| status.to_sym == s }.map(&:first)
        end
      end

    private

      def parse_311(message)
        @nick     = message.params[1]
        @user     = message.params[2]
        @host     = message.params[3]
        @realname = message.trail
      end
      
      def parse_319(message)
        # Channels with the "+" prefix don't support modes.
        parsed = message.to_s.split.map do |channel|
          if channel.start_with?("++")
            [nil, channel]
          else
            channel.match(/([^#&!])? ([#&!+]\S+)/x).captures
          end
        end

        @channels += parsed.map(&:last)

        parsed.each do |status, channel|
          @statuses[channel] = status.nil? ? nil : status.to_sym
        end
      end

      def parse_312(message)
        @server      = message.params[2]
        @server_info = message.trail
      end

      def parse_301(message)
        @away = true
      end

      def parse_313(message)
        @operator = true
      end

      def parse_317(message)
        @seconds_idle = message.params[2].to_i
      end
    end
  end
end
