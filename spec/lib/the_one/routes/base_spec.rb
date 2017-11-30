RSpec.describe TheOne::Routes::Base do
  subject { described_class.new }

  describe '#files' do
    it 'memoize downloaded files' do
      expect(subject).to receive(:download).and_return({}).once
      5.times { subject.files }
    end
  end

  describe '#download' do
    let(:response) { double(body: '') }

    it 'get and unzip routes' do
      expect_any_instance_of(Faraday::Connection).to(
        receive(:get).with(described_class::ZION_ROUTES_URL) { response }
      )
      expect(subject).to receive(:unzip).with(response.body)
      subject.download
    end
  end

  describe '#upload' do
    let(:route) { build(:route) }

    it 'send post request with route payload' do
      expect_any_instance_of(Faraday::Connection).to(
        receive(:post).with(described_class::ZION_ROUTES_URL, route)
      )
      subject.upload(route)
    end
  end

  describe '#connection' do
    specify do
      expect(subject.send(:connection)).to be_kind_of(Faraday::Connection)
    end
  end
end
