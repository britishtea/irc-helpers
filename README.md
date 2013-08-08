# irc-helpers

The IRC protocol implemented as a Ruby mixin.

## Description

irc-helpers is a collection of Modules that you can include in your classes so 
you can:

1. Generate IRC messages: `privmsg "#ruby", "Hi #ruby!" # => PRIVMSG #ruby :Hi #ruby!`. 
2. Look up numeric replies by constant: `RPL_WELCOME # => :"001"`.

Convenient!

## Installation

`gem install irc-helpers`

## Usage

```ruby
require "irc/rfc2812"

class Bot
  include IRC::RFC2812::Commands
  include IRC::RFC2812::Constants

  def handle_message(message)
    case message.command
      when RPL_MYINFO then join "#ruby"
      when RPL_BOUNCE then "..."
    end
  end

  # ...
end
```

## Documentation

API documentation can be found here: 
[http://britishtea.github.io/irc-helpers][documentation].

[documentation]: http://britishtea.github.io/irc-helpers/frames.html#!http%3A//britishtea.github.io/irc-helpers/

## Contributing

TODO: A contribution workflow.

## LICENSE

See the LICENSE file.
