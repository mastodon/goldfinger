describe Goldfinger::Client do
  context 'with HTTPS available' do
    describe '#finger' do
      before do
        stub_request(:get, 'https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no').to_return(body: fixture('quitter.no_.well-known_webfinger.json'), headers: { content_type: 'application/jrd+json' })
      end

      subject { Goldfinger::Client.new('acct:gargron@quitter.no') }

      it 'returns a result' do
        expect(subject.finger).to be_instance_of Goldfinger::Result
      end

      it 'performs a single HTTP request' do
        subject.finger
        expect(a_request(:get, 'https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no')).to have_been_made.once
      end
    end
  end

  context 'with only HTTP available' do
    describe '#finger' do
      before do
        stub_request(:get, 'https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no').to_raise(HTTP::Error)
        stub_request(:get, 'http://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no').to_return(body: fixture('quitter.no_.well-known_webfinger.json'), headers: { content_type: 'application/jrd+json' })
      end

      subject { Goldfinger::Client.new('acct:gargron@quitter.no') }

      it 'raises an error' do
        expect { subject.finger }.to raise_error HTTP::Error
      end
    end
  end

  context 'with XRD missing' do
    describe '#finger' do
      before do
        stub_request(:get, 'https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no').to_raise(HTTP::Error)
        stub_request(:get, 'http://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no').to_raise(HTTP::Error)
        stub_request(:get, 'https://quitter.no/.well-known/host-meta').to_raise(HTTP::Error)
        stub_request(:get, 'http://quitter.no/.well-known/host-meta').to_raise(HTTP::Error)
      end

      subject { Goldfinger::Client.new('acct:gargron@quitter.no') }

      it 'raises an error' do
        expect { subject.finger }.to raise_error(HTTP::Error)
      end
    end
  end

  describe '#finger' do
    before do
      stub_request(:get, 'https://ab.com/.well-known/webfinger?resource=acct:someone%40gmail.com@ab.com').to_return(status: 404)
      stub_request(:get, 'https://ab.com/.well-known/webfinger?resource=acct:someone%2540gmail.com@ab.com').to_return(body: fixture('quitter.no_.well-known_webfinger.json'), headers: { content_type: 'application/jrd+json' })
    end

    subject { Goldfinger::Client.new('acct:someone%40gmail.com@ab.com') }

    it 'should correctly handle %40 in acct uri' do
      expect(subject.finger).to be_instance_of Goldfinger::Result
    end
  end
end
