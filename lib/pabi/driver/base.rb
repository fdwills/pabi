require 'json'
require 'net/https'
require 'uri'

module Pabi::Driver
  SANDBOX = 0
  PRODUCT = 1

  class Base
    attr_reader :type, :env, :url

    def initialize(type, env, url)
      @type = type
      @env = env
      @url = url
    end

    def validate(date, option)
      puts "do nothing."
    end

    def info
      "Type #{self.type}, env #{self.env}, url #{self.url}\n"
    end
  end
end
