module TheOne::Routes
  class Base
    ZION_HTTP_URL   = ENV.fetch('ZION_HTTP_URL').freeze
    ZION_PASSPHRASE = ENV.fetch('ZION_PASSPHRASE').freeze
    ZION_ROUTES_URL = '/the_one/routes'.freeze

    include TheOne::Helpers

    def files
      @files ||= download
    end

    def download
      response = connection.get(ZION_ROUTES_URL).body
      unzip(response)
    end

    def upload(payload)
      connection.post(ZION_ROUTES_URL, payload)
    end

    private

    def source
      @source ||= self.class.name.split('::').last.downcase
    end

    def connection
      @connection ||= begin
        params = { passphrase: ZION_PASSPHRASE, source: source }
        Faraday.new(url: ZION_HTTP_URL, params: params) do |c|
          c.request  :retry, max: 5, interval: 0.1, backoff_factor: 2
          c.request  :url_encoded
          c.response :logger
          c.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
