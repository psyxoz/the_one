require 'rubygems'
require 'time'
require 'csv'
require 'zip'
require 'multi_json'
require 'faraday'

require_relative 'the_one/helpers'
require_relative 'the_one/routes/base'
require_relative 'the_one/routes/sentinels'
require_relative 'the_one/routes/sniffers'
require_relative 'the_one/routes/loopholes'

module TheOne
  ROUTES_CLASSES = [ Routes::Sentinels, Routes::Sniffers, Routes::Loopholes ]

  def self.perform
    ROUTES_CLASSES.each do |klass|
      instance = klass.new
      instance.routes do |route|
        instance.upload(route)
      end
    end
  end
end
