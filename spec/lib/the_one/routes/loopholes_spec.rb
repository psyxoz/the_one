RSpec.describe TheOne::Routes::Loopholes do
  subject { described_class.new }

  let(:files) do
    {
      'routes.json' => file_fixture('loopholes/routes.json').read,
      'node_pairs.json' => file_fixture('loopholes/node_pairs.json').read,
    }
  end

  before do
    allow(subject).to receive(:files).and_return(files)
  end

  describe '#routes' do
    let(:route) { build(:route) }

    specify do
      expect(subject).to receive(:grouped_routes).and_return({ key: [route] })
      expect { |b| subject.routes(&b) }.to yield_with_args(route)
    end
  end

  describe '#node_pairs' do
    let(:node_pairs) { subject.send(:node_pairs) }

    specify do
      expect(node_pairs).to be_a_kind_of(Hash)
      expect(node_pairs.keys).to contain_exactly('1', '2', '3')
    end
  end

  describe '#grouped_routes' do
    let(:grouped_routes) { subject.send(:grouped_routes) }
    let(:expected_grouped_routes) do
      {
        '1' => [
          {
            route_id: '1', node_pair_id: '1', start_time: '2030-12-31T13:00:04Z',
            end_time: '2030-12-31T13:00:05Z', start_node: 'gamma', end_node: 'theta'
          },{
            route_id: '1', node_pair_id: '3', start_time: '2030-12-31T13:00:05Z',
            end_time: '2030-12-31T13:00:06Z', start_node: 'theta', end_node: 'lambda'
          }
        ],
        '2' => [
          {
            route_id: '2', node_pair_id: '2', start_time: '2030-12-31T13:00:05Z',
            end_time: '2030-12-31T13:00:06Z', start_node: 'beta', end_node: 'theta'
          }, {
            route_id: '2', node_pair_id: '3', start_time: '2030-12-31T13:00:06Z',
            end_time: '2030-12-31T13:00:07Z', start_node: 'theta', end_node: 'lambda'
          }
        ]
      }
    end

    specify do
      expect(grouped_routes).to be_a_kind_of(Hash)
      expect(grouped_routes.keys).to contain_exactly('1', '2')

      grouped_routes.each do |key, value|
        expect(value).to match_array(expected_grouped_routes[key])
      end
    end
  end
end
