autoload 'Logger', 'logger'
require 'forwardable'
require 'pcloud/client'
require 'pcloud/version'
require 'pcloud/request'
require 'pcloud/resource'

module Pcloud
  BASE_URL = 'https://api.pcloud.com'.freeze

  class << self
    extend Forwardable
    def_delegators :default_client, :username=, :password=
    def_delegators :default_client, :get

    attr_writer :logger

    def logger
      @logger ||= begin
        log = Logger.new($stdout)
        log.level = Logger::INFO
        log
      end
    end

    def default_client
      @default_client ||= begin
        Pcloud::Client.new
      end
    end
  end
end
