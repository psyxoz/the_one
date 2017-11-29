module TheOne::Routes
  class Base
    ZION_URL            = ENV.fetch('ZION_URL').freeze
    ZION_PASSPHRASE     = ENV.fetch('ZION_PASSPHRASE').freeze
    HTTP_MAX_RETRY      = ENV.fetch('HTTP_MAX_RETRY').to_i
    HTTP_RETRY_INTERVAL = ENV.fetch('HTTP_RETRY_INTERVAL').to_f
    HTTP_BACKOFF_FACTOR = ENV.fetch('HTTP_BACKOFF_FACTOR').to_i

    class << self
      def download
        unzip(connection.get('/routes', source: self.class.name).body)
      end

      def upload(payload)
        connection.post('/routes', payload)
      end

      private

      def connection
        @connection ||= Faraday.new(url: ZION_URL, params: { passphrase: ZION_PASSPHRASE }) do |c|
          c.adapter :net_http
          c.request :retry,
                    max: HTTP_MAX_RETRY,
                    interval: HTTP_RETRY_INTERVAL,
                    backoff_factor: HTTP_BACKOFF_FACTOR
        end
      end

      def unzip(response)
        {}.tap do |files|
          Zip::File.open_buffer(response).each do |item|
            next unless item.file?
            name = item.name.split('/').last
            files[name] = item.get_input_stream.read
          end
        end
      end
    end
  end
end
