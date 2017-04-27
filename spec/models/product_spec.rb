require 'rails_helper'

# Test suite for the Product model
RSpec.describe Product, type: :model do
  # ensure Product model has a 1:m relationship with the OrderLine model
  it { should have_many(:order_lines).dependent(:destroy) }

  # Validation tests
  # ensure columns name, description, status, price are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:status) }

  it "has a valid factory" do
    expect(FactoryGirl.create(:product)).to be_valid
  end
end
