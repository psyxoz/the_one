RSpec.describe TheOne::Routes::Sentinels do
  subject { described_class.new }

  let(:files) do
    { 'routes.csv' => file_fixture('sentinels/routes.csv').read }
  end

  before do
    allow(subject).to receive(:files).and_return(files)
  end

  describe '#routes' do
    let(:routes) { build_list(:route, 2) }
    let(:parsed_routes) do
      routes.map.with_index do |route, index|
        if index.zero?
          { index: index, time: route[:start_time], node: route[:start_node] }
        else
          { index: index, time: route[:end_time], node: route[:end_node] }
        end
      end
    end

    before do
      expect(subject).to receive(:parsed_routes).and_return({ key: parsed_routes })
    end

    specify do
      expect { |b| subject.routes(&b) }.to yield_with_args({
        start_node: 'alpha',
        end_node: 'gamma',
        start_time: routes.first[:start_time],
        end_time: routes.first[:end_time]
      })
    end

    context 'skip not finished routes' do
      let(:routes) { build_list(:route, 1) }

      specify do
        expect { |b| subject.routes(&b) }.to_not yield_with_args
      end
    end
  end

  describe '#parsed_routes' do
    let(:parsed_routes) { subject.send(:parsed_routes) }

    specify do
      expect(parsed_routes).to be_a_kind_of(Hash)
      expect(parsed_routes.keys).to contain_exactly('1', '2', '3')
    end
  end
end
