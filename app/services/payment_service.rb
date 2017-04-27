class PaymentService
  require 'active_support/all'
  require 'net/http'

  include Rails.application.routes.url_helpers

  attr_reader :order, :customer, :back_after_payment_url

  def initialize(attrs = {})
    @order                  = attrs[:order]
    @customer               = attrs[:customer]
    @back_after_payment_url = attrs[:back_after_payment_url]
  end

  def proceed
    request_params = {
      lastname: customer.lastname,
      firstname: customer.firstname,
      total: order.total,
      # API callback for success payment
      success_callback: success_callback_api_order_url(id: order.id, token: ''),
      # API callback for rejected payment
      reject_callback: reject_callback_api_order_url(id: order.id, token: ''),
      # the place where we should redirect client after payment
      back_after_payment_url: back_after_payment_url
    }

    # POST request to payment dummy service
    uri  = URI.parse('http://localhost:4567/payment')
    http = Net::HTTP.new(uri.host, uri.port)

    request      = Net::HTTP::Post.new(uri, initheader = { 'Content-Type' => 'application/json' })
    request.body = request_params.to_json

    response = http.request(request)
    response = JSON.parse(response.body)

    # we've got token of the payemnt session and url which client will visit
    { token: response['token'], redirect_url: response['redirect'] }
  end
end
