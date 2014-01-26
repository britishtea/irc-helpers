module IRC
  # Public: Represents a Message. This class is intended to be subclassed. Its
  # `#parse` and `#valid?` methods are not implemented and should be redefined.
  class Message
    # Public: Gets the raw message String.
    attr_reader :raw

    # Public: Gets the prefix.
    attr_reader :prefix

    # Public: Gets the command Symbol.
    attr_reader :command

    alias_method :to_sym, :command

    # Public: Gets the parameters Array. It includes the trail.
    attr_reader :params

    # Public: Gets the trail String.
    attr_reader :trail

    alias_method :to_s, :trail
    alias_method :to_str, :to_s

    # Public: Gets the Time the message was parsed at.
    attr_reader :time

    def initialize(raw)
      parsed   = parse raw

      @raw     = raw
      @prefix  = parsed[0]
      @command = parsed[1].downcase.to_sym
      @params  = parsed[2]
      @trail   = parsed[2].last
      @time    = Time.now
    end

    # Public: Parses a raw message. It should return an Array of three elements 
    # (prefix, command, parameters).
    #
    # raw_message - The raw message String.
    #
    # Examples
    #
    #   parse(":prefix COMMAND parameter :the trail")
    #   # => ["prefix", "COMMAND", ["parameter", "the trail"]]
    #
    # Returns an Array of three elements.
    # Raises NotImplementedError when not implemented (default).
    def parse(raw_message)
      raise NotImplementedError, "#{self}#parse is not implemented."
    end

    # Public: Checks a raw message for validity. It should return true when 
    # `raw_message` is a valid message, false otherwise.
    #
    # raw_message - The raw message String.
    #
    # Returns true or false.
    # Raises NotImplementedError when not implemented (default).
    def valid?(raw_message)
      raise NotImplementedError, "#{self}#valid? is not implemented."
    end

    # Public: Checks the equality of the trail and other with the "equals 
    # operator" (`==`).
    def ==(other)
      self.trail == other
    end

    # Public: Checks the equality of the trail and other with the "spermy 
    # operator" (`=~`).
    def =~(other)
      self.trail =~ other
    end

    # Public: Returns an Array of the following form: `["prefix", :command, 
    # ["parameters","including","trail"]]`.
    #
    # Returns an Array.
    def to_a
      [self.prefix, self.command, self.params]
    end

    # Public: Returns a Hash of the following form: 
    #     { 
    #       :prefix     => "prefix", 
    #       :command    => :command,
    #       :parameters => ["parameters", "including", "trail"], 
    #       :trail      => "trail"
    #     }
    #
    # Returns a Hash.
    def to_h
      { :prefix     => self.prefix,  :command    => self.command,
        :parameters => self.params,  :trail      => self.trail }
    end
  end
end
