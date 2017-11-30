module TheOne::Routes
  class Loopholes < Base
    def routes
      grouped_routes.each do |_, items|
        route = {
          start_node: items.first[:start_node],
          end_node: items.last[:end_node],
          start_time: Time.parse(items.first[:start_time]).strftime('%FT%T'),
          end_time: Time.parse(items.last[:end_time]).strftime('%FT%T')
        }

        yield(route)
      end
    end

    private

    def node_pairs
      @node_pairs ||= {}.tap do |rows|
        MultiJson.load(files['node_pairs.json'], symbolize_keys: true)[:node_pairs].each do |row|
          rows[row[:id]] = row
        end
      end
    end

    def grouped_routes
      Hash.new { |h,k| h[k] = [] }.tap do |rows|
        MultiJson.load(files['routes.json'], symbolize_keys: true)[:routes].each do |row|
          node_pair = node_pairs[row[:node_pair_id]]
          next unless node_pair

          rows[row[:route_id]] << row.merge(
            start_node: node_pair[:start_node],
            end_node: node_pair[:end_node]
          )
        end
      end
    end
  end
end