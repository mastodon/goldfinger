describe Goldfinger::Result do
  shared_examples 'a working finger result' do
    subject { Goldfinger::Result.new(response) }

    describe '#links' do
      it 'returns a non-empty array' do
        expect(subject.links).to be_instance_of Array
        expect(subject.links).to_not be_empty
      end
    end

    describe '#link' do
      it 'returns a value for a given rel' do
        expect(subject.link('http://webfinger.net/rel/profile-page').href).to eql 'https://quitter.no/gargron'
      end

      it 'returns nil if no such link exists' do
        expect(subject.link('zzzz')).to be_nil
      end

      it 'returns titles map' do
        expect(subject.link('http://spec.example.net/photo/1.0').title('en')).to eql 'User Photo'
      end

      it 'returns a properties map' do
        expect(subject.link('http://spec.example.net/photo/1.0').property('http://spec.example.net/created/1.0')).to eql '1970-01-01'
      end
    end

    describe '#subject' do
      it 'returns the subject' do
        expect(subject.subject).to eql 'acct:gargron@quitter.no'
      end
    end

    describe '#aliases' do
      it 'returns a non-empty array' do
        expect(subject.aliases).to be_instance_of Array
        expect(subject.aliases).to_not be_empty
      end
    end

    describe '#properties' do
      it 'returns an array' do
        expect(subject.properties).to be_instance_of Array
        expect(subject.properties).to_not be_empty
      end
    end

    describe '#property' do
      it 'returns the value for a key' do
        expect(subject.property('http://webfinger.example/ns/name')).to eql 'Bob Smith'
      end

      it 'returns nil if no such property exists' do
        expect(subject.property('zzzz')).to be_nil
      end
    end
  end

  context 'when the input mime type is application/xrd+xml' do
    before do
      stub_request(:get, 'https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no').to_return(body: fixture('quitter.no_.well-known_webfinger.xml'), headers: { content_type: 'application/xrd+xml' })
    end

    let(:response) { HTTP.get('https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no') }

    it_behaves_like 'a working finger result'
  end

  context 'when the input mime type is application/jrd+json' do
    before do
      stub_request(:get, 'https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no').to_return(body: fixture('quitter.no_.well-known_webfinger.json'), headers: { content_type: 'application/jrd+json' })
    end

    let(:response) { HTTP.get('https://quitter.no/.well-known/webfinger?resource=acct:gargron@quitter.no') }

    it_behaves_like 'a working finger result'
  end
end
