describe Goldfinger::Result do
  context 'application/xrd+xml' do
    let(:headers) { h = HTTP::Headers.new; h.set(HTTP::Headers::CONTENT_TYPE, 'application/xrd+xml'); h }
    let(:body) { File.read(fixture_path('quitter.no_.well-known_webfinger.xml')) }

    subject { Goldfinger::Result.new(headers, body) }

    describe '#links' do
      it 'returns a non-empty array' do
        expect(subject.links).to be_instance_of Array
        expect(subject.links).to_not be_empty
      end
    end

    describe '#link' do
      it 'returns a value for a given rel' do
        expect(subject.link('http://webfinger.net/rel/profile-page')[:href]).to eql 'https://quitter.no/gargron'
      end
    end
  end

  context 'application/jrd+json' do
    let(:headers) { h = HTTP::Headers.new; h.set(HTTP::Headers::CONTENT_TYPE, 'application/jrd+json'); h }
    let(:body) { File.read(fixture_path('quitter.no_.well-known_webfinger.json')) }

    subject { Goldfinger::Result.new(headers, body) }

    describe '#links' do
      it 'returns a non-empty array' do
        expect(subject.links).to be_instance_of Array
        expect(subject.links).to_not be_empty
      end
    end

    describe '#link' do
      it 'returns a value for a given rel' do
        expect(subject.link('http://webfinger.net/rel/profile-page')[:href]).to eql 'https://quitter.no/gargron'
      end
    end
  end
end
