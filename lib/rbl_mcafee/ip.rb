module RblMcafee
  class Ip
    attr_reader :ip

    def initialize(ip)
      @ip = ip
    end

    def valid?
      ipv4? || ipv6?
    end

    private

    def ipv4?
      !!ip.match(Resolv::IPv4::Regex)
    end

    def ipv6?
      !!ip.match(Resolv::IPv6::Regex)
    end
  end
end
