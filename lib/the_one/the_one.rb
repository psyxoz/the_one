require 'rubygems'
require 'time'
require 'csv'
require 'zip'
require 'multi_json'
require 'faraday'

require_relative 'helpers'
require_relative 'routes/base'
require_relative 'routes/sentinels'
require_relative 'routes/sniffers'
require_relative 'routes/loopholes'

module TheOne
  def self.perform
    [ Routes::Sentinels, Routes::Sniffers, Routes::Loopholes ].each do |klass|
      instance = klass.new
      instance.routes do |route|
        instance.upload(route)
      end
    end
  end
end
