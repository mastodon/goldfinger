describe Goldfinger::Result do
  shared_examples 'a working finger result' do
    subject { Goldfinger::Result.new(headers, body) }

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
    let(:headers) { h = HTTP::Headers.new; h.set(HTTP::Headers::CONTENT_TYPE, 'application/xrd+xml'); h }
    let(:body) { File.read(fixture_path('quitter.no_.well-known_webfinger.xml')) }

    it_behaves_like 'a working finger result'
  end

  context 'when the input mime type is application/jrd+json' do
    let(:headers) { h = HTTP::Headers.new; h.set(HTTP::Headers::CONTENT_TYPE, 'application/jrd+json'); h }
    let(:body) { File.read(fixture_path('quitter.no_.well-known_webfinger.json')) }

    it_behaves_like 'a working finger result'
  end
end
