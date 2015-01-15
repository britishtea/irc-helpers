module IRC
  # Public: Represents a Message. This class is intended to be subclassed. Its
  # `.parse` and `#valid?` methods are not implemented and should be redefined.
  #
  # .parse should take a String and return a three-element Array.
  # #valid? should return true or false.
	class Prefix
    # Public: Gets the raw message String.
    attr_reader :raw

    # Public: Gets the nick String.
    attr_reader :nick

    # Public: Gets the user String.
    attr_reader :user

    # Public: Gets the host String.
    attr_reader :host

    # Public: Initializes the prefix. If both `user` and `host` are `nil`,
    # assumes `raw_prefix` to be a prefix String (e.g. `"nick!user@host.com"`).
    #
    # raw_prefix - A raw prefix String *or* a nickname String.
    # user       - A username String (default: nil).
    # host       - A hostname String (default: nil).
    #
    # Examples
    #
    #   IRC::Prefix.new("nick!user@host.com")
    #   IRC::Prefix.new("nick", "user", "host.com")
    def initialize(raw_prefix, user = nil, host = nil)
      if user.nil? && host.nil?
        @raw = raw_prefix
        @nick, @user, @host = self.class.parse(raw_prefix)
      else
        @nick, @user, @host = raw_prefix, user, host
        @raw = to_s
      end
    end

    # Public: Checks the equality of the prefix and other. The comparison is
    # case-insensitive. Wildcards are ignored.
    def ==(other)
      unless other.respond_to? :to_str
        raise TypeError, "no implicit conversion of #{other.class} into String"
      end

      finnish_downcase(self.to_s) == finnish_downcase(other.to_str)
    end

    # Public: Checks the equality of the prefix and other. The comparison is
    # case-insensitive. Wildcards are honored.
    def =~(other)
      self.to_regexp =~ other
    end

    alias_method :eql?, :==

    def hash
      self.to_s.hash
    end

    def to_regexp
      regexp_string = finnish_case_insensitivity(to_s)
      regexp_string.gsub! /[?*\.]/, "?" => "\\S", "*" => "\\S*", "." => "\\."

      Regexp.new "^#{regexp_string}$", Regexp::IGNORECASE
    end

    def to_s
      "#{@nick || "*"}!#{@user || "*"}@#{@host || "*"}"
    end

    alias_method :to_str, :to_s

  private

    # Internal: Replaces non-standard "uppercase" characters with their 
    # "lowercase". This method is meant to be redefined.
    def finnish_downcase(string)
      string.downcase
    end

    # Internal: Replaces non-standard "uppercase" and "lowercase" with both 
    # their "uppercase" and "lowercase", Regexp style. This method is meant to
    # be redefined. Should return a String.
    def finnish_case_insensitivity(string)
      string
    end
	end
end
