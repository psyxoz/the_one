module TheOne::Routes
  class Sentinels < Base
    def self.perform
      routes.each do |route|
        upload(route)
      end
    end

    def self.routes
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

    def self.data
      rows = Hash.new { |h,k| h[k] = [] }
      CSV.parse(download['routes.csv'], headers: true, header_converters: :symbol, skip_blanks: true) do |row|
        rows[row[:route_id]] << row
      end
    end
  end
end