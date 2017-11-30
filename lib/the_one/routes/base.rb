module TheOne::Routes
  class Base
    ZION_HTTP_URL   = ENV.fetch('ZION_HTTP_URL').freeze
    ZION_PASSPHRASE = ENV.fetch('ZION_PASSPHRASE').freeze

    include TheOne::Helpers

    def files
      @files ||= download
    end

    def download
      unzip(connection.get('/routes', source: self.class.name).body)
    end

    def upload(payload)
      connection.post('/routes', payload)
    end

    private

    def connection
      @connection ||= Faraday.new(url: ZION_HTTP_URL, params: { passphrase: ZION_PASSPHRASE }) do |c|
        c.adapter(:net_http)
      end
    end
  end
end
