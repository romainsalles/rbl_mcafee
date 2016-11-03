require "rbl_mcafee/version"
require "rbl_mcafee/ip"
require 'resolv'

module RblMcafee
  class Zone
    PBL = :pbl
    SBL = :sbl
    XBL = :xbl

    attr_reader :ip

    def initialize(ip)
      raise ArgumentError, 'Invalid IP' unless RblMcafee::Ip.new(ip).valid?

      @ip = ip
    end

    def pbl?
      zone == PBL
    end

    def sbl?
      zone == SBL
    end

    def xbl?
      zone == XBL
    end


  private

    def zone
      return @zone if defined? @zone

      @zone = extract_zone(resolved_ip)
    end

    # Lookup the IP address on "cidr.bl.mcafee.com"
    def resolved_ip
      return @resolved_ip if defined? @resolved_ip

      reversed_ip = ip.split('.').reverse.join('.')
      @resolved_ip = Resolv::getaddress("#{reversed_ip}.cidr.bl.mcafee.com")

      rescue Resolv::ResolvError
        @resolved_ip = nil
      rescue Resolv::ResolvTimeout
        raise RblMcafee::Timeout
    end


    # @see https://kc.mcafee.com/corporate/index?page=content&id=KB53783
    # If the reply is in the format 127.0.0.XXX, the host is listed in the
    # McAfee RBL (@see below)
    MC_AFEE_RBL_LISTED_REGEX = /^127\.0\.0\.\d{1,3}$/

    # @see https://www.spamhaus.org/faq/section/DNSBL%20Usage#202
    #
    # DNSBL | Returns       | Contains
    # ------+---------------+---------------------------------------------------
    # SBL   | 127.0.0.2-3	  | Static UBE sources, verified spam services
    #       |               | (hosting or support) and ROKSO spammers
    # XBL   | 127.0.0.4-7	  | Illegal 3rd party exploits, including proxies,
    #       \               | worms and trojan exploits
    # PBL   | 127.0.0.10-11	| IP ranges which should not be delivering
    #       |               | unauthenticated SMTP email.
    def extract_zone(resolved_ip)
      return nil if resolved_ip.nil?
      return nil unless resolved_ip.match(MC_AFEE_RBL_LISTED_REGEX)

      case resolved_ip.split('.').last.to_i
      when 2..3   then SBL
      when 4..7   then XBL
      when 10..11 then PBL
      else nil
      end
    end
  end
end
