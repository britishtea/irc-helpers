module IRC
  # Public: Represents a Message. This class is intended to be subclassed. Its
  # `#parse` and `#valid?` methods are not implemented and should be redefined.
	class Prefix
    # Public: Parses a raw prefix. It should return an Array of three elements
    # (nick, user, host).
    #
    # raw_prefix - A raw prefix String.
    #
    # Examples
    #
    #   Prefix.parse("nick!user@host.com")
    #   # => ["nick", "user", "host.com"]
    #
    # Returns an Array of three elements.
    # Raises NotImplementedError when not implemented (default).
    def self.parse(raw_prefix)
      raise NotImplementedError, "#{self}.parse is not implemented."
    end

    # Public: Gets the raw message String.
    attr_reader :raw

    # Public: Gets the nick String.
    attr_reader :nick

    # Public: Gets the user String.
    attr_reader :user

    # Public: Gets the host String.
    attr_reader :host

    # Public: Initializes the prefix.
    def initialize(raw_prefix)
      @raw = raw_prefix

      @nick, @user, @host = self.class.parse raw_prefix
    end

    # Public: Checks the prefix for validity. It should return `true` when the 
    # prefix is valid, `false` otherwise.
    #
    # Returns true or false.
    # Raises NotImplementedError when not implemented (default).
    def valid?
      raise NotImplementedError, "#{self.class}#valid? is not implemented."
    end

    # Public: Checks the equality of the prefix and other. The comparison is
    # case-insensitive (including conversion of []\~ to {}|^, see: 
    # https://tools.ietf.org/html/rfc2812#section-2.2). Wildcards are 
    # ignored.
    def ==(other)
      unless other.respond_to? :to_str
        raise TypeError, "no implicit conversion of #{other.class} into String"
      end

      downcased_self  = self.to_s.tr("A-Z[]\\\\~", "a-z{}|^")
      downcased_other = other.to_str.tr("A-Z[]\\\\~", "a-z{}|^")

      downcased_self == downcased_other
    end

    # Public: Checks the equality of the prefix and other. The comparison is
    # case-insensite (including conversion of []\~ to {}|^, see:
    # https://tools.ietf.org/html/rfc2812#section-2.2). Wildcards are 
    # honored. Uses #to_regexp under the hood.
    def =~(other)
      self.to_regexp =~ other
    end

    def to_a
      [self.nick, self.user, self.host]
    end

    def to_h
      { :nick => self.nick, :user => self.user, :host => self.host }
    end

    def to_regexp
      # This is an ugly hack and should be replaced with something beautiful.
      escaped  = Regexp.escape to_s
      prepared = escaped.gsub(/(\\.|~)/) do |char|
        CONVERSIONS[char[-1,1]] || char
      end

      Regexp.new "^#{prepared}$", Regexp::IGNORECASE
    end

    def to_s
      "#{@nick || "*"}!#{@user || "*"}@#{@host || "*"}"
    end

    alias_method :to_str, :to_s

  private

    CONVERSIONS = {
      '?'  => '\S',
      '*'  => '\S*',
      '['  => '(\[|\{)',   '{' => '(\[|\{)',
      ']'  => '(\]|\})',   '}' => '(\]|\})',
      '\\' => '(\\\\|\|)', '|' => '(\\\\|\|)', # one of the backslashes will be 
      '~'  => '(~|\^)',    '^' => '(~|\^)'     # replaced by the gsub. so gross.
    }
	end
end
