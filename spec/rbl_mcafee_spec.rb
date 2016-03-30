require 'rbl_mcafee'

describe RblMcafee do
  subject { RblMcafee.blacklisted?(ip_address) }
  let(:ip_address) { '127.0.0.1' }

  context 'with a non listed IP address' do
    it 'returns false' do
      Resolv.stub(:getaddress) { raise Resolv::ResolvError.new('whatever') }

      expect(subject).to be false
    end
  end

  context 'with a listed IP address' do
    it 'returns true' do
      Resolv.stub(:getaddress) { '127.0.0.11' }

      expect(subject).to be true
    end
  end

  context 'when a timeout error is raised by Resolv' do
    it 'raises a RblMcafee::Timeout error' do
      Resolv.stub(:getaddress) { raise Resolv::ResolvTimeout }

      expect{subject}.to raise_error(RblMcafee::Timeout)
    end
  end

  context 'when an unknown exception is raised by Resolv' do
    it 'is re-raised by .blacklisted?' do
      Resolv.stub(:getaddress) { raise 'oops' }

      expect{subject}.to raise_error('oops')
    end
  end

  context 'when an invalid IP address is passed as argument' do
    let(:ip_address) { '001.8.9.10' }

    it 'raises an ArgumentError' do
      expect{subject}.to raise_error(ArgumentError)
    end
  end

  context 'when a valid website address is passed as argument' do
    let(:ip_address) { 'www.mcafee.com' }

    it 'raises an ArgumentError' do
      expect{subject}.to raise_error(ArgumentError)
    end
  end
end
