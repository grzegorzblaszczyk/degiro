require 'json'

module DeGiro
  class CreateOrder
    BUY_SELL    = { buy: 0, sell: 1 }.freeze
    ORDER_TYPES = { limited: 0, stop_limited: 1, market_order: 2, stop_loss: 3 }.freeze
    TIME_TYPES  = { day: 1, permanent: 3 }.freeze

    def initialize(connection)
      @connection = connection
    end

    def create_buy_order(product_id:, size:, price:)
      order = order(BUY_SELL[:buy], product_id, size, price)
      binding.pry
      response = check_order(order)
      binding.pry
      confirmation_id = JSON.parse(response.body)['confirmationId']
      confirm_order(order, confirmation_id)
    end

    def create_sell_order(product_id:, size:, price:)
      order = order(BUY_SELL[:sell], product_id, size, price)
      confirmation_id = JSON.parse(check_order(order).body)['confirmationId']
      confirm_order(order, confirmation_id)
    end

    private

    def order(type, product_id, size, price)
      {
        buysell:   type,
        orderType: ORDER_TYPES[:limited],
        productId: product_id,
        size:      size,
        timeType:  TIME_TYPES[:permanent],
        price:     price
      }
    end

    def check_order(order)
      binding.pry
      @connection.post(check_order_url) do |req|
        req.headers['Content-Type'] = 'application/json; charset=UTF-8'
        req.body = order.to_json
      end
    end

    def confirm_order(order, confirmation_id)
      @connection.post(confirm_order_url(confirmation_id)) do |req|
        req.headers['Content-Type'] = 'application/json; charset=UTF-8'
        req.body = order.to_json
      end
    end

    def check_order_url
      "#{@connection.urls_map['trading_url']}/v5/checkOrder" \
      ";jsessionid=#{@connection.session_id}" \
      "?intAccount=#{@connection.user_data['int_account']}" \
      "&sessionId=#{@connection.session_id}"
    end

    def confirm_order_url(confirmation_id)
      "#{@connection.urls_map['trading_url']}/v5/order/#{confirmation_id}" \
      ";jsessionid=#{@connection.session_id}" \
      "?intAccount=#{@connection.user_data['int_account']}" \
      "&sessionId=#{@connection.session_id}"
    end
  end
end
