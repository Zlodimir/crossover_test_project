require 'rails_helper'

RSpec.describe 'Order', type: :request do
  context 'Not logged user' do
    it "Can't see orders" do
      FactoryGirl.create(:order)

      get '/api/orders', headers: { format: :json }
      expect(response.status).to eq 401
    end

    it "Can't see particular order" do
      order = FactoryGirl.create(:order)

      get "/api/orders/#{order.id}", headers: { format: :json }
      expect(response.status).to eq 401
    end

    it "Can't create orders" do
      FactoryGirl.create(:order)

      post "/api/orders", headers: { format: :json }, params: { order: { total: 0.0 } }
      expect(response.status).to eq 401
    end

    it "Can't use payment method" do
      order = FactoryGirl.create(:order)

      put "/api/orders/#{order.id}/payment", headers: { format: :json }
      expect(response.status).to eq 401
    end
  end

  context 'Logged user' do
    before :each do
      @user = FactoryGirl.create(:customer)
      @auth_headers = @user.create_new_auth_token

      # mock payment service
      @payment_service = double('payment_service')
      allow(@payment_service).to receive(:proceed).and_return({ token: 'token', redirect_url: 'redirect_url' })
    end

    it "Should see his own orders only" do
      order = FactoryGirl.create(:order)
      order.customer = @user
      order.save
      # let's create another order which is not belongs to our user
      FactoryGirl.create(:order)

      get '/api/orders', headers: @auth_headers
      expect(response).to be_success
      expect(json.length).to eq(1)
      # ensure that order we've got is the order of our user
      expect(json[0]['order_no']).to eq(order.order_no)
      expect(json[0]['customer_id']).to eq(@user.id)
    end

    it "Should see particular order" do
      order = FactoryGirl.create(:order)
      order.customer = @user
      order.save

      get "/api/orders/#{order.id}", headers: @auth_headers
      expect(response).to be_success
      expect(json['customer_id']).to eq(@user.id)
    end

    it "Should create orders" do
      product = FactoryGirl.create(:product)

      expect do
        post "/api/orders", headers: @auth_headers, params: { order: { order_lines_attributes: [{ product_id: product.id, qty: 1 }] } }
      end.to change { Order.count }.by 1
      expect(response).to be_success
    end

    it "Should pay for the order" do
      order = FactoryGirl.create(:order)
      order.customer = @user
      order.save

      put "/api/orders/#{order.id}/payment", headers: @auth_headers, params: { id: order.id, back_after_payment_url: 'back_after_payment_url' }
      expect(response).to be_success
    end

    it "Can't pay for order which is not belongs to him" do
      order = FactoryGirl.create(:order)

      put "/api/orders/#{order.id}/payment", headers: @auth_headers, params: { id: order.id, back_after_payment_url: 'back_after_payment_url' }
      expect(response.status).to eq 401
    end
  end

  context 'Logged admin' do
    before :each do
      @user = FactoryGirl.create(:admin)
      @auth_headers = @user.create_new_auth_token
    end

    it "Should see his own orders only" do
      order = FactoryGirl.create(:order)
      order.customer = @user
      order.save
      # let's create another order which is not belongs to our user
      FactoryGirl.create(:order)

      get '/api/orders', headers: @auth_headers
      expect(response).to be_success
      expect(json.length).to eq(1)
      # ensure that order we've got is the order of our user
      expect(json[0]['order_no']).to eq(order.order_no)
      expect(json[0]['customer_id']).to eq(@user.id)
    end

    it "Should see particular order" do
      order = FactoryGirl.create(:order)
      order.customer = @user
      order.save

      get "/api/orders/#{order.id}", headers: @auth_headers
      expect(response).to be_success
      expect(json['customer_id']).to eq(@user.id)
    end

    it "Should create orders" do
      product = FactoryGirl.create(:product)

      expect do
        post "/api/orders", headers: @auth_headers, params: { order: { order_lines_attributes: [{ product_id: product.id, qty: 1 }] } }
      end.to change { Order.count }.by 1
      expect(response).to be_success
    end

    it "Should pay for the order" do
      order = FactoryGirl.create(:order)
      order.customer = @user
      order.save

      put "/api/orders/#{order.id}/payment", headers: @auth_headers, params: { id: order.id, back_after_payment_url: 'back_after_payment_url' }
      expect(response).to be_success
    end

    it "Can't pay for order which is not belongs to him" do
      order = FactoryGirl.create(:order)

      put "/api/orders/#{order.id}/payment", headers: @auth_headers, params: { id: order.id, back_after_payment_url: 'back_after_payment_url' }
      expect(response.status).to eq 401
    end
  end

  context "Payment service" do
    it "Can't approve payment without valid token" do
      order = FactoryGirl.create(:order)
      order.payment_token = "123456"

      get "/api/orders/#{order.id}/success_callback/123", headers: { format: :json }
      expect(response.status).to eq 401
    end

    it "Can approve payment with valid token" do
      order = FactoryGirl.create(:order)
      order.payment_token = "123456"
      order.save

      get "/api/orders/#{order.id}/success_callback/123456", headers: { format: :json }, params: { back_after_payment_url: Base64.encode64('test_url') }
      order.reload

      expect(order.paid).to eq(true)
    end

    it "Can touch 'reject payment' method" do
      order = FactoryGirl.create(:order)

      get "/api/orders/#{order.id}/reject_callback/123456", headers: { format: :json }, params: { back_after_payment_url: Base64.encode64('test_url') }
      order.reload

      expect(order.paid).to eq(false)
    end
  end
end
