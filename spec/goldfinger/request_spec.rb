describe Goldfinger::Request do
  describe '#perform' do
    before do
      stub_request(:get, 'example.com').to_return(body: 'OK')
    end

    subject { Goldfinger::Request.new(:get, 'http://example.com').perform }

    it 'returns a http response' do
      expect(subject).to be_a HTTP::Response
    end
  end
end
