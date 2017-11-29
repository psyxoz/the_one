module TheOne::Routes
  class Sentinels < Base
    class << self
      def routes
        data.each_with_object([]) do |(_, items), memo|
          next if items.size < 2
          items.sort_by! { |item| item[:index] }

          memo << {
            start_node: items.first[:node],
            end_node: items.last[:node],
            start_time: Time.parse(items.first[:time]).strftime('%FT%T'),
            end_time: Time.parse(items.last[:time]).strftime('%FT%T')
          }
        end
      end

      def data
        rows = Hash.new { |h,k| h[k] = [] }
        CSV.parse(download['routes.csv'], headers: true, header_converters: :symbol, skip_blanks: true) do |row|
          rows[row[:route_id]] << row
        end
      end
    end
  end
end
