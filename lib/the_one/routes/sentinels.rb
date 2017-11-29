module TheOne::Routes
  class Sentinels < Base
    class << self
      def routes
        data.each do |items|
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

      def data
        Hash.new { |h,k| h[k] = [] }.tap do |rows|
          CSV.parse(download['routes.csv'], csv_options) do |row|
            rows[row[:route_id]] << row
          end
        end
      end
    end
  end
end
