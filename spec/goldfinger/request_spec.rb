describe Goldfinger::Request do
  describe '#perform' do
    before do
      stub_request(:get, 'example.com').to_return(body: 'OK')
    end

    subject { Goldfinger::Request.new(:get, 'http://example.com').perform }

    it 'returns the body' do
      expect(subject.last.to_s).to eql 'OK'
    end
  end
end
