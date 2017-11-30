module TheOne
  module Helpers
    CSV_OPTIONS = { headers: true, header_converters: :symbol, skip_blanks: true }.freeze

    def unzip(response)
      {}.tap do |items|
        Zip::File.open_buffer(response).each do |item|
          next unless item.file?
          name = item.name.split('/').last
          items[name] = item.get_input_stream.read
        end
      end
    end
  end
end
