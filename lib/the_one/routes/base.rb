module TheOne::Routes
  class Base
    ZION_HTTP_URL   = ENV.fetch('ZION_HTTP_URL').freeze
    ZION_PASSPHRASE = ENV.fetch('ZION_PASSPHRASE').freeze

    include TheOne::Helpers

    def files
      @files ||= download
    end

    def download
      response = connection.get('/the_one/routes').body
      unzip(response)
    end

    def upload(payload)
      connection.post('/the_one/routes', payload)
    end

    private

    def source
      @source ||= self.class.name.split('::').last.downcase
    end

    def connection
      @connection ||= begin
        params = { passphrase: ZION_PASSPHRASE, source: source }
        Faraday.new(url: ZION_HTTP_URL, params: params) do |c|
          c.request  :url_encoded
          c.response :logger
          c.adapter Faraday.default_adapter
        end
      end
    end
  end
end
