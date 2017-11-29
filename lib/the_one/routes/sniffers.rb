module TheOne::Routes
  class Sniffers < Base
    class << self
      def routes
        files = download
        sequences = parse_sequences(files['sequences.csv'])
        node_times = parse_node_times(files['node_times.csv'])

        CSV.parse(files['routes.csv'], csv_options) do |route|
          next unless sequences.include?(route[:route_id])

          data = {}
          duration_in_milliseconds = 0
          start_time = Time.parse(route[:time]).utc

          sequences[route[:route_id]].sort.each do |node_time_id|
            next unless node_times[node_time_id]

            data[:start_node] ||= node_times[node_time_id][:start_node]
            data[:end_node] = node_times[node_time_id][:end_node]
            duration_in_milliseconds += node_times[node_time_id][:duration_in_milliseconds].to_i
          end

          data[:start_time] = start_time.strftime('%FT%T')
          data[:end_time] = (start_time + duration_in_milliseconds).strftime('%FT%T')

          next if data[:start_node].nil? || data[:end_node].nil?
          yield(data)
        end
      end

      private

      def parse_sequences(csv)
        Hash.new { |h,k| h[k] = [] }.tap do |rows|
          CSV.parse(csv, csv_options) do |row|
            rows[row[:route_id]] << row[:node_time_id]
          end
        end
      end

      def parse_node_times(csv)
        [].tap do |rows|
          CSV.parse(csv, csv_options) do |row|
            rows[row[:node_time_id]] = row
          end
        end
      end
    end
  end
end
