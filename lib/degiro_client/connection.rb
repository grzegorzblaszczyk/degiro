require 'json'
require 'faraday'
require 'faraday/detailed_logger'
require 'faraday-cookie_jar'
require 'logger'

require_relative 'urls_map.rb'
require_relative 'user_data.rb'
require_relative 'errors.rb'

module DeGiro
  class Connection
    extend Forwardable

    def_delegators :@conn, :get, :post
    attr_reader :urls_map, :user_data, :session_id

    BASE_TRADER_URL = 'https://trader.degiro.nl'.freeze

    def initialize(login, password)

      my_logger = Logger.new("degiro_client.log")
      my_logger.level = Logger::DEBUG

      @conn = Faraday.new(url: BASE_TRADER_URL) do |builder|
        builder.use :cookie_jar
        builder.use Faraday::Response::RaiseError
        builder.response :detailed_logger, my_logger
        builder.adapter Faraday.default_adapter
      end

      response = @conn.post('/login/secure/login') do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          username: login,
          password: password,
          isPassCodeReset: false,
          isRedirectToMobile: false,
          queryParams: { reason: 'session_expired' }
        }.to_json
      end

      @session_id = response.headers['set-cookie'][/JSESSIONID=(.*?);/m, 1]
      raise MissingSessionIdError, 'Could not find valid session id' if @session_id == '' || @session_id.nil?

      @urls_map = UrlsMap.new(JSON.parse(@conn.get('/login/secure/config').body))
      url = "#{@urls_map['pa_url']}/client?sessionId=#{@session_id}"
      @user_data = UserData.new(JSON.parse(@conn.get(url).body)["data"])
    end
  end
end
