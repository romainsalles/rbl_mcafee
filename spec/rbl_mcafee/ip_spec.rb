require 'rbl_mcafee/ip'

describe RblMcafee::Ip do
  subject { RblMcafee::Ip.new(ip_address) }

  context 'with an IPv4 address' do
    let(:ip_address) { '1.160.10.240' }

    it 'detects the IP as IPv4' do
      expect(subject.send(:ipv4?)).to be true
    end

    it 'does not detect the IP as IPv6' do
      expect(subject.send(:ipv6?)).to be false
    end

    it 'detects the IP as valid' do
      expect(subject.valid?).to be true
    end
  end

  context 'with an IPv6 address' do
    let(:ip_address) { '3ffe:1900:4545:3:200:f8ff:fe21:67cf' }

    it 'does not detect the IP as IPv4' do
      expect(subject.send(:ipv4?)).to be false
    end

    it 'detects the IP as IPv6' do
      expect(subject.send(:ipv6?)).to be true
    end

    it 'detects the IP as valid' do
      expect(subject.valid?).to be true
    end
  end
end
