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
    [ Routes::Sentinels ].each do |klass|
      klass.routes.each { |route| upload(route) }
    end
  end
end