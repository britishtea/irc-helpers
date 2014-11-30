module IRC
  # Public: Represents a Message. This class is intended to be subclassed. Its
  # `#parse` and `#valid?` methods are not implemented and should be redefined.
  class Message
    include Comparable

    # Public: Parses a raw message. It should return an Array of four elements 
    # (prefix, command, parameters, trail).
    #
    # raw_message - The raw message String.
    #
    # Examples
    #
    #   Message.parse(":prefix COMMAND parameter :the trail")
    #   # => ["prefix", "COMMAND", ["parameter"], "the trail"]
    #
    # Returns an Array of four elements.
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

    # Public: Gets the parameters Array. It does not include the trail.
    attr_reader :params

    # Public: Gets the trail String.
    attr_reader :trail

    alias_method :to_s, :trail
    alias_method :to_str, :to_s

    # Public: Gets the Time the message was parsed at.
    attr_reader :time

    def initialize(raw)
      parsed = self.class.parse raw

      @raw     = raw
      @prefix  = parsed[0] # TODO: Maybe store a Prefix. But how to know which one?
      @command = String(parsed[1]).downcase.to_sym
      @params  = parsed[2]
      @trail   = parsed[3]
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

    # Public: Checks the equality. If `other` is an IRC::Message the raw message
    # is compared. If a String-like object (responds to #to_str) is given, the
    # trail of the message is compared.
    #
    # other - An IRC::Message or String-like object.
    def ==(other)
      if other.respond_to? :raw
        return self.raw.chomp == other.raw.chomp
      elsif other.respond_to? :to_str
        self.trail == other.to_str
      else
        raise TypeError, "no implicit conversion of #{other.class} into String"
      end
    end

    # Public: Checks the equality of the trail and other with the "spermy 
    # operator" (`=~`).
    #
    # other - A String or regexp.
    def =~(other)
      self.trail =~ other
    end

    # Public: ...
    def <=>(other)
      return nil unless other.respond_to? :time

      self.time <=> other.time
    end

    # Public: Matches the trail of a Message against a pattern, taking into
    # account the command and the parameters. Executes the block if the pattern
    # (plus command and parameters) matches. If `pattern` is a Regexp, the block
    # receives its captures as arguments.
    #
    # command - A command Symbol, String or Integer.
    # params  - An Array of parameters (defaults to []).
    # block   - The block that should be executed.
    #
    # Examples
    # 
    #   message.match :privmsg, "!help" do
    #     "..."
    #   end
    # 
    #   message.match :command, /^!help (\S+)$/ do |plugin|
    #     "..."
    #   end
    # 
    #   message.match :command, "parameter", "pattern" do
    #     "..."
    #   end
    # 
    #   message.match :command, "parameter", nil do
    #     "..."
    #   end
    #
    # Returns false if pattern does not match.
    # Returns true or the result of the block if the pattern does match.
    def match(command, *params, &block)
      pattern = params.pop

      return false unless command_matches?(command)
      return false unless self.params == params || params.empty?

      block ||= -> * { true }

      if pattern.nil?
        return block.call
      elsif pattern.is_a? Regexp
        matchdata = self.trail.match pattern
        return matchdata.nil? ? false : block.call(*matchdata.captures)
      elsif pattern.respond_to?(:to_str) && self.trail == pattern
        return block.call
      end
    end

    # Public: Returns an Array of the following form: `["prefix", :command, 
    # ["parameters","including","trail"]]`.
    #
    # Returns an Array.
    def to_a
      [self.prefix, self.command, self.params, self.trail]
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

    # Public: Returns a new Message with all mIRC color codes removed.
    def strip_colors
      self.class.new self.raw.gsub(/\x03(?:[019]?[0-9](?:,[019]?[0-9])?)?/, "")
    end

  private

    # Internal: Checks if the command matches `command`. Neccessary to correctly
    # match :"001" and 001.
    #
    # command - A Numeric, Symbol or String.
    #
    # Returns a Boolean.
    def command_matches?(command)
      case command
        when Numeric then
          return false unless self.command.to_s.to_i == command.to_i
        when Symbol  then
          return false unless self.command == command.to_sym
        else
          return false unless self.command.to_s == command.to_s
      end

      return true
    end
  end
end
