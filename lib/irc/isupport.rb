module IRC
  class ISupport
    # messages - IRC::Messages.
    def initialize(*messages)
      unless valid_messages? messages
        raise ArgumentError
      end

      pairs   = messages.map(&:params).flatten
      @parsed = Hash[pairs.map { |param| param.split("=") }]
    end

    def casemapping
      @parsed.fetch("CASEMAPPING", :rfc1459).to_sym
    end

    def channel_limits
      pairs = @parsed.fetch("CHANLIMIT", "").split ","

      pairs.each_with_object Hash.new do |pair, result|
        prefixes, limit = pair.split ":"

        prefixes.each_char do |prefix|
          if limit
            result[prefix] = limit.to_i 
          else
            result[prefix] = Float::INFINITY
          end
        end
      end
    end

    def channel_modes
      parts = @parsed["CHANMODES"].split(",").map(&:chars)

      Hash[[:A, :B, :C, :D].zip parts]
    end

    def channel_length
      @parsed.fetch("CHANNELLEN", 200).to_i
    end

    def channel_types
      @parsed.fetch("CHANTYPES", "#&").chars
    end

    def exceptions?
      @parsed.key? "EXCEPT"
    end

    def exception_mode
      @parsed["EXCEPT"]
    end

    def channel_id_lengths
      pairs = @parsed.fetch("IDCHAN", "").split(",")

      pairs.each_with_object Hash.new do |pair, result|
        prefix, length = pair.split ":"

        result[prefix] = length.to_i
      end
    end

    def invite_exceptions?
      @parsed.key? "INVEX"
    end

    def invite_exception_mode
      @parsed["INVEX"]
    end

    def kick_length
      @parsed["KICKLEN"].to_i
    end

    def max_list_items
      pairs = @parsed["MAXLIST"].split(",")

      pairs.each_with_object Hash.new do |pair, result|
        modes, max = pair.split(":")

        modes.each_char { |char| result[char.to_sym] = max.to_i }
      end
    end

    def max_modes
      @parsed.fetch("MODES", 3).to_i
    end

    def network
      @parsed["NETWORK"]
    end

    def nick_length
      @parsed.fetch("NICKLEN", 9).to_i
    end

    def prefix
      modes, prefixes = @parsed.fetch("PREFIX", "(ov)@+")[1..-1].split ")"

      Hash[modes.chars.zip prefixes.chars]
    end

    def list?
      @parsed.key? "SAFELIST"
    end

    def status_messages?
      @parsed.key? "STATUSMSG"
    end

    def status_messages
      @parsed.fetch("STATUSMSG", "").chars
    end

    def standards
      @parsed.fetch("STD", "").split(",")
    end

    def maximum_targets
      pairs = @parsed.fetch("TARGMAX", "").split(",")

      pairs.each_with_object Hash.new do |pair, result|
        command, max = pair.split(":")

        result[command.downcase.to_sym] = max.to_i
      end
    end

    def topic_length
      @parsed.fetch("TOPICLEN").to_i
    rescue KeyError
      return Float::INFINITY
    end

  private

    def valid_messages?(messages)
      messages.all? { |message| message.match 005, /supported by this server/ }
    end
  end
end
