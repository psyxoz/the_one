module TheOne::Routes
  class Sentinels < Base
    def routes
      parse_routes.each do |_, items|
        next if items.size < 2
        items.sort_by! { |item| item[:index] }

        route = {
          start_node: items.first[:node],
          end_node: items.last[:node],
          start_time: Time.parse(items.first[:time]).strftime('%FT%T'),
          end_time: Time.parse(items.last[:time]).strftime('%FT%T')
        }

        yield(route)
      end
    end

    private

    def parse_routes
      Hash.new { |h,k| h[k] = [] }.tap do |rows|
        CSV.parse(files['routes.csv'], CSV_OPTIONS) do |row|
          rows[row[:route_id]] << row
        end
      end
    end
  end
end
