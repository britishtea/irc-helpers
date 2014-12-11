module IRC
  module RFC2812
    module Constants
      # Command Responses (https://tools.ietf.org/html/rfc2812#section-5.1)

      RPL_WELCOME         = :"001"
      RPL_YOURHOST        = :"002"
      RPL_CREATED         = :"003"
      RPL_MYINFO          = :"004"
      RPL_BOUNCE          = :"005"
      RPL_USERHOST        = :"302"
      RPL_ISON            = :"303"
      RPL_AWAY            = :"301"
      RPL_UNAWAY          = :"305"
      RPL_NOWAWAY         = :"306"
      RPL_WHOISUSER       = :"311"
      RPL_WHOISSERVER     = :"312"
      RPL_WHOISOPERATOR   = :"313"
      RPL_WHOISIDLE       = :"317"
      RPL_ENDOFWHOIS      = :"318"
      RPL_WHOISCHANNELS   = :"319"
      RPL_WHOWASUSER      = :"314"
      RPL_ENDOFWHOWAS     = :"369"
      RPL_LISTSTART       = :"321"
      RPL_LIST            = :"322"
      RPL_LISTEND         = :"323"
      RPL_UNIQOPIS        = :"325"
      RPL_CHANNELMODEIS   = :"324"
      RPL_NOTOPIC         = :"331"
      RPL_TOPIC           = :"332"
      RPL_INVITING        = :"341"
      RPL_SUMMONING       = :"342"
      RPL_INVITELIST      = :"346"
      RPL_ENDOFINVITELIST = :"347"
      RPL_EXCEPTLIST      = :"348"
      RPL_ENDOFEXCEPTLIST = :"349"
      RPL_VERSION         = :"351"
      RPL_WHOREPLY        = :"352"
      RPL_ENDOFWHO        = :"315"
      RPL_NAMREPLY        = :"353"
      RPL_ENDOFNAMES      = :"366"
      RPL_LINKS           = :"364"
      RPL_ENDOFLINKS      = :"365"
      RPL_BANLIST         = :"367"
      RPL_ENDOFBANLIST    = :"368"
      RPL_INFO            = :"371"
      RPL_ENDOFINFO       = :"374"
      RPL_MOTDSTART       = :"375"
      RPL_MOTD            = :"372"
      RPL_ENDOFMOTD       = :"376"
      RPL_YOUREOPER       = :"381"
      RPL_REHASHING       = :"382"
      RPL_YOURESERVICE    = :"383"
      RPL_TIME            = :"391"
      RPL_USERSSTART      = :"392"
      RPL_USERS           = :"393"
      RPL_ENDOFUSERS      = :"394"
      RPL_NOUSERS         = :"395"
      RPL_TRACELINK       = :"200"
      RPL_TRACECONNECTING = :"201"
      RPL_TRACEHANDSHAKE  = :"202"
      RPL_TRACEUNKNOWN    = :"203"
      RPL_TRACEOPERATOR   = :"204"
      RPL_TRACEUSER       = :"205"
      RPL_TRACESERVER     = :"206"
      RPL_TRACESERVICE    = :"207"
      RPL_TRACENEWTYPE    = :"208"
      RPL_TRACECLASS      = :"209"
      RPL_TRACERECONNECT  = :"210"
      RPL_TRACELOG        = :"261"
      RPL_TRACEEND        = :"262"
      RPL_STATSLINKINFO   = :"211"
      RPL_STATSCOMMANDS   = :"212"
      RPL_ENDOFSTATS      = :"219"
      RPL_STATSUPTIME     = :"242"
      RPL_STATSOLINE      = :"243"
      RPL_UMODEIS         = :"221"
      RPL_SERVLIST        = :"234"
      RPL_SERVLISTEND     = :"235"
      RPL_LUSERCLIENT     = :"251"
      RPL_LUSEROP         = :"252"
      RPL_LUSERUNKNOWN    = :"253"
      RPL_LUSERCHANNELS   = :"254"
      RPL_LUSERME         = :"255"
      RPL_ADMINME         = :"256"
      RPL_ADMINLOC1       = :"257"
      RPL_ADMINLOC2       = :"258"
      RPL_ADMINEMAIL      = :"259"
      RPL_TRYAGAIN        = :"263"

      # Error replies (https://tools.ietf.org/html/rfc2812#section-5.2)

      ERR_NOSUCHNICK        = :"401"
      ERR_NOSUCHSERVER      = :"402"
      ERR_NOSUCHCHANNEL     = :"403"
      ERR_CANNOTSENDTOCHAN  = :"404"
      ERR_TOOMANYCHANNELS   = :"405"
      ERR_WASNOSUCHNICK     = :"406"
      ERR_TOOMANYTARGETS    = :"407"
      ERR_NOSUCHSERVICE     = :"408"
      ERR_NOORIGIN          = :"409"
      ERR_NORECIPIENT       = :"411"
      ERR_NOTEXTTOSEND      = :"412"
      ERR_NOTOPLEVEL        = :"413"
      ERR_WILDTOPLEVEL      = :"414"
      ERR_BADMASK           = :"415"
      ERR_UNKNOWNCOMMAND    = :"421"
      ERR_NOMOTD            = :"422"
      ERR_NOADMININFO       = :"423"
      ERR_FILEERROR         = :"424"
      ERR_NONICKNAMEGIVEN   = :"431"
      ERR_ERRONEUSNICKNAME  = :"432"
      ERR_NICKNAMEINUSE     = :"433"
      ERR_NICKCOLLISION     = :"436"
      ERR_UNAVAILRESOURCE   = :"437"
      ERR_USERNOTINCHANNEL  = :"441"
      ERR_NOTONCHANNEL      = :"442"
      ERR_USERONCHANNEL     = :"443"
      ERR_NOLOGIN           = :"444"
      ERR_SUMMONDISABLED    = :"445"
      ERR_USERSDISABLED     = :"446"
      ERR_NOTREGISTERED     = :"451"
      ERR_NEEDMOREPARAMS    = :"461"
      ERR_ALREADYREGISTRED  = :"462"
      ERR_NOPERMFORHOST     = :"463"
      ERR_PASSWDMISMATCH    = :"464"
      ERR_YOUREBANNEDCREEP  = :"465"
      ERR_YOUWILLBEBANNED   = :"466"
      ERR_KEYSET            = :"467"
      ERR_CHANNELISFULL     = :"471"
      ERR_UNKNOWNMODE       = :"472"
      ERR_INVITEONLYCHAN    = :"473"
      ERR_BANNEDFROMCHAN    = :"474"
      ERR_BADCHANNELKEY     = :"475"
      ERR_BADCHANMASK       = :"476"
      ERR_NOCHANMODES       = :"477"
      ERR_BANLISTFULL       = :"478"
      ERR_NOPRIVILEGES      = :"481"
      ERR_CHANOPRIVSNEEDED  = :"482"
      ERR_CANTKILLSERVER    = :"483"
      ERR_RESTRICTED        = :"484"
      ERR_UNIQOPPRIVSNEEDED = :"485"
      ERR_NOOPERHOST        = :"491"
      ERR_UMODEUNKNOWNFLAG  = :"501"
      ERR_USERSDONTMATCH    = :"502"

      # This error reply is used but not defined in RFC2812. Its value is 416
      # per https://www.alien.net.au/irc/irc2numerics.html.
      ERR_TOOMANYMATCHES  = ":416"

      # Reserved numerics (https://tools.ietf.org/html/rfc2812#section-5.3)

      RPL_SERVICEINFO   = :"231"
      RPL_ENDOFSERVICES = :"232"
      RPL_SERVICE       = :"233"
      RPL_NONE          = :"300"
      RPL_WHOISCHANOP   = :"316"
      RPL_KILLDONE      = :"361"
      RPL_CLOSING       = :"362"
      RPL_CLOSEEND      = :"363"
      RPL_INFOSTART     = :"371"
      RPL_MYPORTIS      = :"384"

      RPL_STATSCLINE    = :"213"
      RPL_STATSNLINE    = :"214"
      RPL_STATSILINE    = :"215"
      RPL_STATSKLINE    = :"216"
      RPL_STATSQLINE    = :"217"
      RPL_STATSYLINE    = :"218"
      RPL_STATSVLINE    = :"240"
      RPL_STATSLLINE    = :"241"
      RPL_STATSHLINE    = :"244"
      RPL_STATSSLINE    = :"244"
      RPL_STATSPING     = :"246"
      RPL_STATSBLINE    = :"247"
      RPL_STATSDLINE    = :"250"

      ERR_NOSERVICEHOST = :"492"

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
          :replies => [RPL_TOPIC],
          :errors  => [ERR_NEEDMOREPARAMS, ERR_BANNEDFROMCHAN, 
                       ERR_INVITEONLYCHAN, ERR_BADCHANNELKEY, ERR_CHANNELISFULL,
                       ERR_BADCHANMASK, ERR_NOSUCHCHANNEL, ERR_TOOMANYCHANNELS, 
                       ERR_TOOMANYTARGETS, ERR_UNAVAILRESOURCE]
        },
        :part => {
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
          :replies => [RPL_NOTOPIC, RPL_TOPIC],
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
          :errors  => [ERR_NEEDMOREPARAMS, ERR_NOSUCHCHANNEL, ERR_BADCHANMASK,
                       ERR_CHANOPRIVSNEEDED, ERR_USERNOTINCHANNEL,
                       ERR_NOTONCHANNEL]
        },
        :privmsg => {
          :replies => [RPL_AWAY],
          :errors  => [ERR_NORECIPIENT, ERR_NOTEXTTOSEND, ERR_CANNOTSENDTOCHAN,
                       ERR_NOTOPLEVEL, ERR_WILDTOPLEVEL, ERR_TOOMANYTARGETS, 
                       ERR_NOSUCHNICK]
        },
        :notice => {
          :replies => [RPL_AWAY],
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
end
