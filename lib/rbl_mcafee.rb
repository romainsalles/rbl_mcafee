require "rbl_mcafee/version"
require 'resolv'

module RblMcafee
  # Indicates a timeout checking an IP address
  class Timeout < TimeoutError; end

  # @see https://kc.mcafee.com/corporate/index?page=content&id=KB53783
  # If the reply is in the format 127.0.0.XXX, the host is listed in the McAfee
  # RBL
  MC_AFEE_RBL_LISTED_REGEX = /^127\.0\.0\.\d{1,3}$/

  def self.blacklisted?(ip)
    if !ip.match(Resolv::IPv6::Regex) && !ip.match(Resolv::IPv4::Regex)
      raise ArgumentError, 'Invalid IP'
    end

    reversed_ip = ip.split('.').reverse.join('.')
    resolved_ip = Resolv::getaddress("#{reversed_ip}.cidr.bl.mcafee.com")
    return !!resolved_ip.match(MC_AFEE_RBL_LISTED_REGEX)

    rescue Resolv::ResolvError
      false
    rescue Resolv::ResolvTimeout
      raise RblMcafee::Timeout
  end
end
