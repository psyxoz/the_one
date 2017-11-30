RSpec.describe TheOne do
  describe '.perform' do
    let(:route) { build(:route) }

    it 'upload parsed routes' do
      described_class::ROUTES_CLASSES.each do |klass|
        expect_any_instance_of(klass).to receive(:routes).and_yield(route)
        expect_any_instance_of(klass).to receive(:upload).with(route)
      end

      described_class.perform
    end
  end
end
