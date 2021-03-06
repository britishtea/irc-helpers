require "irc/rfc2812/prefix"

module IRC
  # Public: Represents a Message. This class is intended to be subclassed. Its
  # `.parse` and `#valid?` methods are not implemented and should be redefined.
  #
  # .parse should take a message String and return a four-element Array.
  # #valid? should return true or false.
  class Message
    # Public: Gets the raw message String.
    attr_reader :raw

    # Public: Gets the prefix.
    attr_reader :prefix

    # Public: Gets the command Symbol.
    attr_reader :command

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
      @prefix  = wrap_prefix(parsed[0]) unless parsed[0].nil?
      @command = String(parsed[1]).downcase.to_sym
      @params  = parsed[2]
      @trail   = parsed[3]
      @time    = Time.now
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

    # Public: Checks the command for equality. Optionally takes a pattern (a 
    # String or Regexp) which is checked for equality against the trail. If a 
    # block is given it is executed when both the command and the pattern match.
    #
    # command - A command Symbol, String or Integer.
    # pattern - A String or Regexp pattern (default: nil).
    # block   - The block that should be executed (optional).
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
    # Returns false if pattern does not match.
    # Returns true or the result of the block if the pattern does match.
    def match(command, pattern = nil, &block)
      unless command_matches?(command)
        return false
      end 

      unless block_given?
        block = proc { true }
      end

      if pattern.nil? || (pattern.respond_to?(:to_str) && self == pattern)
        block.call
      elsif pattern.is_a?(Regexp)
        matchdata = pattern.match(self.trail)

        if matchdata.nil?
          return false
        end
        
        block.call(*matchdata.captures)
      else
        return false
      end

      return true
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

    # Internal: Called from initialize, to wrap the prefix of a message in an
    # object. See IRC::RFC2812::Message#wrap_prefix for an example.
    def wrap_prefix(prefix)
      prefix
    end
  end
end
