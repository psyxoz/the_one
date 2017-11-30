module TheOne::Routes
  class Sniffers < Base
    def routes
      CSV.parse(files['routes.csv'], CSV_OPTIONS) do |raw_route|
        next unless sequences.include?(raw_route[:route_id])

        route = build_route(raw_route)
        next if route[:start_node].nil? || route[:end_node].nil?

        yield(route)
      end
    end

    private

    def build_route(payload)
      {}.tap do |route|
        duration_in_seconds = 0
        start_time = Time.parse(payload[:time]).utc

        sequences[payload[:route_id]].sort.each do |node_time_id|
          next unless node_times[node_time_id]

          route[:start_node] ||= node_times[node_time_id][:start_node]
          route[:end_node] = node_times[node_time_id][:end_node]
          duration_in_seconds += (node_times[node_time_id][:duration_in_milliseconds].to_i / 1000)
        end

        route[:start_time] = start_time.strftime('%FT%T')
        route[:end_time] = (start_time + duration_in_seconds).strftime('%FT%T')
      end
    end

    def sequences
      @sequences ||= Hash.new { |h,k| h[k] = [] }.tap do |rows|
        CSV.parse(files['sequences.csv'], CSV_OPTIONS) do |row|
          rows[row[:route_id]] << row[:node_time_id]
        end
      end
    end

    def node_times
      @node_times ||= [].tap do |rows|
        CSV.parse(files['node_times.csv'], CSV_OPTIONS) do |row|
          rows[row[:node_time_id]] = row
        end
      end
    end
  end
end
