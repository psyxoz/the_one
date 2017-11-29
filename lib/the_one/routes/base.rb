module TheOne::Routes
  class Base
    ZION_HTTP_URL   = ENV.fetch('ZION_HTTP_URL').freeze
    ZION_PASSPHRASE = ENV.fetch('ZION_PASSPHRASE').freeze

    class << self
      def download
        unzip(connection.get('/routes', source: self.name).body)
      end

      def upload(payload)
        connection.post('/routes', payload)
      end

      private

      def unzip(response)
        {}.tap do |files|
          Zip::File.open_buffer(response).each do |item|
            next unless item.file?
            name = item.name.split('/').last
            files[name] = item.get_input_stream.read
          end
        end
      end

      def connection
        @connection ||= Faraday.new(url: ZION_HTTP_URL, params: { passphrase: ZION_PASSPHRASE }) do |c|
          c.adapter(:net_http)
        end
      end

      def csv_options
        @csv_options ||= { headers: true, header_converters: :symbol, skip_blanks: true }
      end
    end
  end
end
