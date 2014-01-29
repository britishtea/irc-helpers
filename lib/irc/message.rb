module IRC
  # Public: Represents a Message. This class is intended to be subclassed. Its
  # `#parse` and `#valid?` methods are not implemented and should be redefined.
  class Message
    # Public: Parses a raw message. It should return an Array of three elements 
    # (prefix, command, parameters).
    #
    # raw_message - The raw message String.
    #
    # Examples
    #
    #   Message.parse(":prefix COMMAND parameter :the trail")
    #   # => ["prefix", "COMMAND", ["parameter", "the trail"]]
    #
    # Returns an Array of three elements.
    # Raises NotImplementedError when not implemented (default).
    def self.parse(raw_message)
      raise NotImplementedError, "#{self}.parse is not implemented."
    end

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
      parsed   = self.class.parse raw

      @raw     = raw
      @prefix  = parsed[0] # TODO: Maybe store a Prefix. But how to know which one?
      @command = parsed[1].downcase.to_sym
      @params  = parsed[2]
      @trail   = parsed[2].last
      @time    = Time.now
    end

    # Public: Checks a the message for validity. It should return `true` when 
    # the message is a valid message, `false` otherwise.
    #
    # Returns true or false.
    # Raises NotImplementedError when not implemented (default).
    def valid?
      raise NotImplementedError, "#{self.class}#valid? is not implemented."
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
