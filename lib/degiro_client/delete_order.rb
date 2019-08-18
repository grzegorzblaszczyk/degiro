require 'json'

module DeGiro
  class DeleteOrder

    def initialize(connection)
      @connection = connection
    end

    def delete_order(id)
      @connection.delete(url(id))
    end

    private

    def url(confirmation_id)
      "#{@connection.urls_map['trading_url']}/v5/order/#{confirmation_id}" \
      ";jsessionid=#{@connection.session_id}" \
      "?intAccount=#{@connection.user_data['int_account']}" \
      "&sessionId=#{@connection.session_id}"
    end

  end
end
