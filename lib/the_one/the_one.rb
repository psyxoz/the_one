require 'rubygems'
require 'time'
require 'csv'
require 'zip'
require 'multi_json'
require 'faraday'

require_relative 'routes/base'
require_relative 'routes/sentinels'

module TheOne
  def self.perform
    [ Routes::Sentinels, Routes::Sniffers ].each do |klass|
      klass.routes do |route|
        upload(route)
      end
    end
  end
end