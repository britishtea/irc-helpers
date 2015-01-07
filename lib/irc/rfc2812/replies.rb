require "irc/rfc2812/constants"

module IRC
  module RFC2812
    include Constants

    # Public: A Hash that matches commands with all possible replies. The key
    # is a command Symbol, the value a Hash with the following keys:
    #
    # :start   - A Symbol, indicating the start of the reply.
    # :end     - An Array of Symbol, indicating the end of a reply.
    # :replies - An Array of Symbols, indicating a reply.
    # :errors  - An Array of Symbol, indicating an error.
    #
    # They values for these keys may also be `nil`.
    REPLIES = {
      :pass => {
        :errors  => [ERR_NEEDMOREPARAMS, ERR_ALREADYREGISTRED]
      },
      :nick => {
        :errors  => [ERR_NONICKNAMEGIVEN, ERR_ERRONEUSNICKNAME, 
                     ERR_NICKNAMEINUSE, ERR_NICKCOLLISION, 
                     ERR_UNAVAILRESOURCE, ERR_RESTRICTED]
      },
      :user => {
        :errors  => [ERR_NEEDMOREPARAMS, ERR_ALREADYREGISTRED]
      },
      :oper => {
        :replies => [RPL_YOUREOPER], 
        :errors  => [ERR_NEEDMOREPARAMS, ERR_NOOPERHOST, ERR_PASSWDMISMATCH]
      },
      :user_mode => {
        :replies => [:mode, RPL_UMODEIS],
        :errors  => [ERR_NEEDMOREPARAMS, ERR_USERSDONTMATCH, 
                     ERR_UMODEUNKNOWNFLAG]
      },
      :service => {
        :replies => [RPL_YOURESERVICE, RPL_YOURHOST, RPL_MYINFO],
        :errors  => [ERR_ALREADYREGISTRED, ERR_NEEDMOREPARAMS, 
                     ERR_ERRONEUSNICKNAME]
      },
      :squit => {
        :errors =>  [ERR_NOPRIVILEGES, ERR_NOSUCHSERVER, ERR_NEEDMOREPARAMS]
      },


      :join => {
        :replies => [:join, RPL_TOPIC],
        :errors  => [ERR_NEEDMOREPARAMS, ERR_BANNEDFROMCHAN, 
                     ERR_INVITEONLYCHAN, ERR_BADCHANNELKEY, ERR_CHANNELISFULL,
                     ERR_BADCHANMASK, ERR_NOSUCHCHANNEL, ERR_TOOMANYCHANNELS, 
                     ERR_TOOMANYTARGETS, ERR_UNAVAILRESOURCE]
      },
      :part => {
        :replies => [:part],
        :errors  => [ERR_NEEDMOREPARAMS, ERR_NOSUCHCHANNEL, ERR_NOTONCHANNEL]
      },
      :channel_mode => {
        :end     => [RPL_ENDOFBANLIST, RPL_ENDOFEXCEPTLIST, 
                     RPL_ENDOFINVITELIST],
        :replies => [:mode, RPL_CHANNELMODEIS, RPL_BANLIST, RPL_EXCEPTLIST, 
                     RPL_INVITELIST, RPL_UNIQOPIS],
        :errors  => [ERR_NEEDMOREPARAMS, ERR_KEYSET, ERR_NOCHANMODES, 
                     ERR_CHANOPRIVSNEEDED, ERR_USERNOTINCHANNEL,
                     ERR_UNKNOWNMODE]
      },
      :topic => {
        :replies => [:topic, RPL_NOTOPIC, RPL_TOPIC],
        :errors  => [ERR_NEEDMOREPARAMS, ERR_NOTONCHANNEL, 
                     ERR_CHANOPRIVSNEEDED, ERR_NOCHANMODES]
      },
      :names => {
        :end     => [RPL_ENDOFNAMES],
        :replies => [RPL_NAMREPLY],
        :errors  => [ERR_TOOMANYMATCHES, ERR_NOSUCHSERVER]
      },
      :list => {
        :end     => [RPL_LISTEND],
        :replies => [RPL_LIST],
        :errors  => [ERR_TOOMANYMATCHES, ERR_NOSUCHSERVER]
      },
      :invite => {
        :replies => [RPL_INVITING, RPL_AWAY],
        :errors  => [ERR_NEEDMOREPARAMS, ERR_NOSUCHNICK, ERR_NOTONCHANNEL,
                     ERR_USERONCHANNEL, ERR_CHANOPRIVSNEEDED] 
      },
      :kick => {
        :replies => [:kick],
        :errors  => [ERR_NEEDMOREPARAMS, ERR_NOSUCHCHANNEL, ERR_BADCHANMASK,
                     ERR_CHANOPRIVSNEEDED, ERR_USERNOTINCHANNEL,
                     ERR_NOTONCHANNEL]
      },
      :privmsg => {
        :replies => [:privmsg, RPL_AWAY],
        :errors  => [ERR_NORECIPIENT, ERR_NOTEXTTOSEND, ERR_CANNOTSENDTOCHAN,
                     ERR_NOTOPLEVEL, ERR_WILDTOPLEVEL, ERR_TOOMANYTARGETS, 
                     ERR_NOSUCHNICK]
      },
      :notice => {
        :replies => [:notice, RPL_AWAY],
        :errors  => [ERR_NORECIPIENT, ERR_NOTEXTTOSEND, ERR_CANNOTSENDTOCHAN,
                     ERR_NOTOPLEVEL, ERR_WILDTOPLEVEL, ERR_TOOMANYTARGETS, 
                     ERR_NOSUCHNICK]
      },


      :motd => {
        :start   => [RPL_MOTDSTART],
        :end     => [RPL_ENDOFMOTD],
        :replies => [RPL_MOTD],
        :errors  => [ERR_NOMOTD]                               
      },
      :lusers => {
        :replies => [RPL_LUSERCLIENT, RPL_LUSEROP, RPL_LUSERUNKNOWN,
                     RPL_LUSERCHANNELS, RPL_LUSERME],
        :errors  => [ERR_NOSUCHSERVER]
      },
      :version => {
        :replies => [RPL_VERSION],
        :errors  => [ERR_NOSUCHSERVER]
      },
      :stats => {
        :end     => [RPL_ENDOFSTATS],
        :replies => [RPL_STATSLINKINFO, RPL_STATSUPTIME, RPL_STATSCOMMANDS,
                     RPL_STATSOLINE],
        :errors  => [ERR_NOSUCHSERVER]         
      },
      :links => {
        :end     => [RPL_ENDOFLINKS],
        :replies => [RPL_LINKS],
        :errors  => [ERR_NOSUCHSERVER]
      },
      :time => {
        :replies => [RPL_TIME],
        :errors  => [ERR_NOSUCHSERVER]
      },
      :connect => {
        :errors  => [ERR_NOSUCHSERVER, ERR_NOPRIVILEGES, ERR_NEEDMOREPARAMS]
      },
      :trace => {
        :end     => [RPL_TRACEEND],
        :replies => [RPL_TRACECONNECTING, RPL_TRACEHANDSHAKE, 
                     RPL_TRACEUNKNOWN, RPL_TRACEOPERATOR, RPL_TRACEUSER, 
                     RPL_TRACESERVER,  RPL_TRACESERVICE, RPL_TRACENEWTYPE, 
                     RPL_TRACECLASS, RPL_TRACELOG]
      },
      :admin => {
        :replies => [RPL_ADMINME, RPL_ADMINLOC1, RPL_ADMINLOC2, 
                     RPL_ADMINEMAIL],
        :errors  => [ERR_NOSUCHSERVER]
      },
      :info => {
        :end     => [RPL_ENDOFINFO],
        :replies => [RPL_INFO],
        :errors  => [ERR_NOSUCHSERVER]
      },
      :servlist => {
        :end     => [RPL_SERVLISTEND],
        :replies => [RPL_SERVLIST]
      },
      :squery => {
        :replies  => [RPL_AWAY],
        :errors   => [ERR_NORECIPIENT, ERR_NOTEXTTOSEND, ERR_CANNOTSENDTOCHAN,
                      ERR_NOTOPLEVEL, ERR_WILDTOPLEVEL, ERR_TOOMANYTARGETS, 
                      ERR_NOSUCHNICK]
      },
      

      :who => {
        :end     => [RPL_ENDOFWHO],
        :replies => [RPL_WHOREPLY],
        :errors  => [ERR_NOSUCHSERVER]
      },
      :whois => {
        :end     => [RPL_ENDOFWHOIS],
        :replies => [RPL_WHOISUSER, RPL_WHOISCHANNELS, RPL_WHOISCHANNELS, 
                     RPL_WHOISSERVER, RPL_AWAY, RPL_WHOISOPERATOR,
                     RPL_WHOISIDLE],
        :errors  => [ERR_NOSUCHSERVER, ERR_NONICKNAMEGIVEN, ERR_NOSUCHNICK]              
      },
      :whowas => {
        :end     => [RPL_ENDOFWHOWAS],
        :replies => [RPL_WHOWASUSER, RPL_WHOISSERVER],
        :errors  => [ERR_NONICKNAMEGIVEN, ERR_WASNOSUCHNICK]
      },


      :kill => {
        :errors  => [ERR_NOPRIVILEGES, ERR_NEEDMOREPARAMS, ERR_NOSUCHNICK,
                    ERR_CANTKILLSERVER]
      },
      :ping => {
        :errors  => [ERR_NOORIGIN, ERR_NOSUCHSERVER]
      },
      :pong => {
        :errors  => [ERR_NOORIGIN, ERR_NOSUCHSERVER]
      },


      :away => {
        :replies => [RPL_UNAWAY, RPL_NOWAWAY]
      },
      :rehash => {
        :replies => [RPL_REHASHING],
        :errors  => [ERR_NOPRIVILEGES]
      },
      :die => {
        :errors => [ERR_NOPRIVILEGES]
      },
      :restart => {
        :errors => [ERR_NOPRIVILEGES]
      },
      :summon => {
        :replies => [RPL_SUMMONING],
        :errors  => [ERR_NORECIPIENT, ERR_FILEERROR, ERR_NOLOGIN, 
                     ERR_NOSUCHSERVER, ERR_SUMMONDISABLED]
      },
      :users => {
        :replies => [RPL_USERSSTART,RPL_USERS, RPL_NOUSERS, RPL_ENDOFUSERS],
        :errors  => [ERR_NOSUCHSERVER, ERR_FILEERROR, ERR_USERSDISABLED]  
      },
      :wallops => {
        :errors  => [ERR_NEEDMOREPARAMS]
      },
      :userhost => {
        :replies => [RPL_USERHOST],
        :errors  => [ERR_NEEDMOREPARAMS]
      },
      :ison => {
        :replies => [RPL_ISON],
        :errors  => [ERR_NEEDMOREPARAMS]
      }
    }
  end
end
