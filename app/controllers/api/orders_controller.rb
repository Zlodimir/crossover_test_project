class Api::OrdersController < ApplicationController
  before_action :authenticate_customer!, except: [:success_callback, :reject_callback]
  before_action :set_order, only: [:payment, :success_callback, :reject_callback, :show]
  before_action :check_access, only: [:payment]

  def index
    @orders = Order.where(customer: current_customer).by_date.map(&:decorate)
  end

  def create
    @order = OrderService.new.prepare(params, current_customer)

    respond_to do |format|
      if @order.save
        format.json { render :show, status: :created, location: api_order_url(@order) }
      else
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def payment
    response = PaymentService.new({ order: @order,
      customer: current_customer,
      back_after_payment_url: params[:back_after_payment_url]
    }).proceed

    # we need to save ID of the payment session to protect ourself in further when we will approve payment
    @order.payment_token = response[:token]
    @order.save

    # we've got url to the payment service, we need to redirect client to it
    redirect_url = response[:redirect_url]

    respond_to do |format|
      format.json { render json: { status: :ok, location: redirect_url } }
    end
  end

  def success_callback
    # we need to check payment token
    fail NotAuthenticatedError if @order.payment_token != params[:token]

    # successfull payment
    @order.paid = true
    @order.save
    redirect_to Base64.decode64(params[:back_after_payment_url])
  end

  def reject_callback
    fail NotAuthenticatedError if @order.payment_token != params[:token]

    redirect_to Base64.decode64(params[:back_after_payment_url])
  end

  def show

  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def check_access
    # client can pay only for his orders
    fail NotAuthenticatedError if @order.customer != current_customer
  end
end
