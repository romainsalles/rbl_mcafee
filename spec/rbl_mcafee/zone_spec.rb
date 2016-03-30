require 'rbl_mcafee'
require 'rbl_mcafee/zone'

describe RblMcafee::Zone do
  subject { RblMcafee::Zone.new('127.0.0.1') }

  # Extract zone
  # ----------------------------------------------------------------------------
  it 'extracts the zones correctly' do
    expect(subject.send(:extract_zone, nil)).to be(nil)
    expect(subject.send(:extract_zone,'127.0.0.1')).to be(nil)
    expect(subject.send(:extract_zone,'127.0.0.2')).to be(RblMcafee::Zone::SBL)
    expect(subject.send(:extract_zone,'127.0.0.3')).to be(RblMcafee::Zone::SBL)
    expect(subject.send(:extract_zone,'127.0.0.4')).to be(RblMcafee::Zone::XBL)
    expect(subject.send(:extract_zone,'127.0.0.5')).to be(RblMcafee::Zone::XBL)
    expect(subject.send(:extract_zone,'127.0.0.6')).to be(RblMcafee::Zone::XBL)
    expect(subject.send(:extract_zone,'127.0.0.7')).to be(RblMcafee::Zone::XBL)
    expect(subject.send(:extract_zone,'127.0.0.8')).to be(nil)
    expect(subject.send(:extract_zone,'127.0.0.9')).to be(nil)
    expect(subject.send(:extract_zone,'127.0.0.10')).to be(RblMcafee::Zone::PBL)
    expect(subject.send(:extract_zone,'127.0.0.11')).to be(RblMcafee::Zone::PBL)
    expect(subject.send(:extract_zone,'127.0.0.12')).to be(nil)
  end

  # PBL zone
  # ----------------------------------------------------------------------------
  context 'with an IP address listed in the PBL zone' do
    before(:each) { Resolv.stub(:getaddress) { '127.0.0.10' } }

    it 'is not detected as belonging to the SBL zone' do
      expect(subject.sbl?).to be false
    end

    it 'is not detected as belonging to the XBL zone' do
      expect(subject.xbl?).to be false
    end

    it 'is detected as belonging to the PBL zone' do
      expect(subject.pbl?).to be true
    end
  end

  # SBL zone
  # ----------------------------------------------------------------------------
  context 'with an IP address listed in the SBL zone' do
    before(:each) { Resolv.stub(:getaddress) { '127.0.0.3' } }

    it 'is detected as belonging to the SBL zone' do
      expect(subject.sbl?).to be true
    end

    it 'is not detected as belonging to the XBL zone' do
      expect(subject.xbl?).to be false
    end

    it 'is not detected as belonging to the PBL zone' do
      expect(subject.pbl?).to be false
    end
  end

  # XBL zone
  # ----------------------------------------------------------------------------
  context 'with an IP address listed in the XBL zone' do
    before(:each) { Resolv.stub(:getaddress) { '127.0.0.4' } }

    it 'is not detected as belonging to the SBL zone' do
      expect(subject.sbl?).to be false
    end

    it 'is detected as belonging to the XBL zone' do
      expect(subject.xbl?).to be true
    end

    it 'is not detected as belonging to the PBL zone' do
      expect(subject.pbl?).to be false
    end
  end

  # Without zone
  # ----------------------------------------------------------------------------
  context 'with an IP address not listed in any zone' do
    before(:each) { Resolv.stub(:getaddress) { raise Resolv::ResolvError } }

    it 'is not detected as belonging to the SBL zone' do
      expect(subject.sbl?).to be false
    end

    it 'is not detected as belonging to the XBL zone' do
      expect(subject.xbl?).to be false
    end

    it 'is not detected as belonging to the PBL zone' do
      expect(subject.pbl?).to be false
    end
  end

  # Exceptions
  # ----------------------------------------------------------------------------
  it 'raises an ArgumentError for invalid IP addresses' do
    RblMcafee::Ip.any_instance.stub(:valid?) { false }

    expect{subject}.to raise_error(ArgumentError)
  end

  it 'raises a RblMcafee::Timeout when a timeout error is raised by Resolv' do
    Resolv.stub(:getaddress) { raise Resolv::ResolvTimeout }

    expect{subject.sbl?}.to raise_error(RblMcafee::Timeout)
    expect{subject.xbl?}.to raise_error(RblMcafee::Timeout)
    expect{subject.pbl?}.to raise_error(RblMcafee::Timeout)
  end

  it 'raises unknown exceptions raised by Resolv' do
    Resolv.stub(:getaddress) { raise 'oops' }

    expect{subject.sbl?}.to raise_error('oops')
    expect{subject.xbl?}.to raise_error('oops')
    expect{subject.pbl?}.to raise_error('oops')
  end
end
