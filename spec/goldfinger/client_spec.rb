describe Goldfinger::Client do
  describe '#finger' do
    before do
      stub_request(:get, 'https://quitter.no/.well-known/host-meta').to_return(body: fixture('quitter.no_.well-known_host-meta'))
      stub_request(:get, 'https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no').to_return(body: fixture('quitter.no_.well-known_webfinger.json'))
    end

    subject { Goldfinger::Client.new('acct:gargron@quitter.no') }

    it 'returns a result' do
      expect(subject.finger).to be_instance_of Goldfinger::Result
    end
  end
end
