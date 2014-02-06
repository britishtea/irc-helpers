# irc-helpers

[![Gem Version](https://badge.fury.io/rb/irc-helpers.png)](latest-version)

A collection of Modules and Classes to parse, generate and represent IRC 
messages.

[latest-version]: http://badge.fury.io/rb/irc-helpers

## Description

First off, irc-helpers doesn't do any networking whatsoever. Instead it 
implements the re-usable parts of an IRC framework or library. It parses, 
generates and represents IRC messages (and parts of IRC messages). 

irc-helpers is nicely namespaced so it can support various specifications of the
IRC protocol. At the moment only the standard desribed in [RFC2812](rfc2812) is 
implemented.

[rfc2812]: https://tools.ietf.org/html/rfc2812

## Usage

Parsing IRC messages:

```ruby
message = IRC::RFC2812::Message.new ":britishtea PRIVMSG #ruby :Hi #ruby!"
message.command # => :privmsg
message.trail # => "Hi #ruby!"
message == "Hi #ruby!" # => true
```

Parsing parts of IRC messages

```ruby
prefix = IRC::RFC2812::Prefix.new "nick!user@host.com"
prefix.nick # => "nick"

mask = IRC::RFC2812::Prefix.new "n?ck!user@*" 
mask =~ "nick!user@host.com" # => true
```

Generating IRC messages:

```ruby
class Handler
  include IRC::RFC2812::Commands

  # ...

  def handle_ping(message)
    pong message.trail
  end

  # Always implement a #raw when including IRC::*::Commands.
  def raw(string)
    connection.write string
  end
end
```

Looking up numeric replies

```ruby
class Handler
  include IRC::RFC2812::Constants

  # ...

  def handle_message(message)
    if message.command == RPL_WELCOME
      "..."
    end
  end
end
```

Convenient!

## Installation

`gem install irc-helpers`

## Documentation

API documentation can be found here: 
[http://britishtea.github.io/irc-helpers](documentation).

[documentation]: http://britishtea.github.io/irc-helpers/

## Contributing

- Write tests (using [cutest](cutest)).
- Write an implementation that passes the tests.
- Send a pull request.

[cutest]: https://github.com/djanowski/cutest

## LICENSE

See the LICENSE file.
