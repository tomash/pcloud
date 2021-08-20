require 'json'
require 'rest-client'

module Pcloud
  class Client
    include Request
    attr_writer :username, :password

    def initialize(options = {})
      @username, @password = options.values_at(:username, :password)
    end

    def get(path, params = {})
      request(:get, path, params)
    end

    def post(path, params = {})
      request(:post, path, params)
    end

    def file
      # Resource.new(self).file()
    end

    def http_client
      @client ||= RestClient::Resource.new(BASE_URL)
    end

    def auth
      @auth ||= begin
        raise ConfigurationError, :username unless @username
        raise ConfigurationError, :password unless @password
        digest = JSON.parse(RestClient.get("#{BASE_URL}/getdigest"))['digest']
        passworddigest = digest_data(@password + digest_data( @username.downcase ) + digest)
        JSON.parse(
          RestClient.get("#{BASE_URL}/userinfo?getauth=1&logout=1", 
          {params: {username: @username, digest: digest, passworddigest: passworddigest}})
        )['auth']
      end
    end

    private

    def request(verb, path, params, payload = {})
      Sample::Request.call(self, verb, path, params, payload)
    end

    def digest_data text
      Digest::SHA1.hexdigest(text)
    end
  end
end
