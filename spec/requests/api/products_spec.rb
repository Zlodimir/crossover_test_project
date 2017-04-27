require 'rails_helper'

RSpec.describe 'Products', type: :request do
  context 'Not logged user' do
    it "should see list of enabled products" do
      FactoryGirl.create(:product)

      get '/api/products', headers: { format: :json }
      expect(response).to be_success
      expect(json.length).to eq(Product.all.count)
    end

    it "can't see disabled products" do
      FactoryGirl.create(:disabled_product)
      total = Product.all.count

      get '/api/products', headers: { format: :json }
      expect(response).to be_success
      expect(total).to eq(1)
      expect(json).to be_empty
    end

    it "should see particular product" do
      product = FactoryGirl.create(:product)

      get "/api/products/#{product.id}", headers: { format: :json }
      expect(response).to be_success
      expect(json['name']).to eq(product.name)
    end

    it "can't create products" do
      post "/api/products", headers: { format: :json }, params: { product: { name: 'Test', description: 'test', price: 123, status: 0 } }
      expect(response.status).to eq 401
    end

    it "can't update products" do
      product = FactoryGirl.create(:product)

      put "/api/products/#{product.id}", headers: { format: :json }, params: { product: { id: product.id, name: 'Test', description: 'test', price: 123, status: 0 } }
      expect(response.status).to eq 401
    end

    it "can't delete products" do
      product = FactoryGirl.create(:product)

      delete "/api/products/#{product.id}", headers: { format: :json }, params: { id: product.id }
      expect(response.status).to eq 401
    end
  end

  context 'Logged user' do
    before :each do
      @user = FactoryGirl.create(:customer)
      @auth_headers = @user.create_new_auth_token
    end

    it "should see list of enabled products" do
      product = FactoryGirl.create(:product)
      FactoryGirl.create(:disabled_product)

      get '/api/products', headers: @auth_headers
      expect(response).to be_success
      expect(json.length).to eq(1)
      expect(json[0]['name']).to eq(product.name)
    end

    it "can't see disabled products" do
      FactoryGirl.create(:disabled_product)
      total = Product.all.count

      get '/api/products', headers: @auth_headers
      expect(response).to be_success
      expect(total).to eq(1)
      expect(json).to be_empty
    end

    it "should see particular product" do
      product = FactoryGirl.create(:product)

      get "/api/products/#{product.id}", headers: @auth_headers
      expect(response).to be_success
      expect(json['name']).to eq(product.name)
    end

    it "can't create products" do
      post "/api/products", headers: @auth_headers, params: { product: { name: 'Test', description: 'test', price: 123, status: 0 } }
      expect(response.status).to eq 401
    end

    it "can't update products" do
      product = FactoryGirl.create(:product)

      put "/api/products/#{product.id}", headers: @auth_headers, params: { product: { id: product.id, name: 'Test', description: 'test', price: 123, status: 0 } }
      expect(response.status).to eq 401
    end

    it "can't delete products" do
      product = FactoryGirl.create(:product)

      delete "/api/products/#{product.id}", headers: @auth_headers, params: { id: product.id }
      expect(response.status).to eq 401
    end
  end

  context 'Logged admin' do
    before :each do
      @user = FactoryGirl.create(:admin)
      @auth_headers = @user.create_new_auth_token
    end

    it "should see list of ALL products" do
      FactoryGirl.create(:product)
      FactoryGirl.create(:disabled_product)

      get '/api/products', headers: @auth_headers
      expect(response).to be_success
      expect(json.length).to eq(Product.all.count)
    end

    it "should see particular product" do
      product = FactoryGirl.create(:product)

      get "/api/products/#{product.id}", headers: @auth_headers
      expect(response).to be_success
      expect(json['name']).to eq(product.name)
    end

    it "can create products" do
      expect do
        post "/api/products", headers: @auth_headers, params: { product: { name: 'Test', description: 'test', price: 123, status: 0 } }
      end.to change { Product.count }.by 1
      expect(response).to be_success
    end

    it "can update products" do
      product = FactoryGirl.create(:product)

      put "/api/products/#{product.id}", headers: @auth_headers, params: { id: product.id, product: { name: 'Test', description: 'test', price: 123, status: 0 } }
      expect(response).to be_success
      product.reload
      expect(product.name).to eq('Test')
    end

    it "can delete products" do
      product = FactoryGirl.create(:product)

      expect do
        delete "/api/products/#{product.id}", headers: @auth_headers, params: { id: product.id }
      end.to change { Product.count }.by -1
      expect(response).to be_success
    end
  end
end
