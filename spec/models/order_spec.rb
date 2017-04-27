require 'rails_helper'

# Test suite for the Order model
RSpec.describe Order, type: :model do
  # ensure Order model has a 1:m relationship with the OrderLine model
  it { should have_many(:order_lines).dependent(:destroy) }
  # ensure Order model belongs to Customer
  it { should belong_to(:customer) }

  # Validation tests
  # ensure columns order_no, date, total are present before saving
  it { should validate_presence_of(:order_no) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:total) }

  it "has a valid factory" do
    expect(FactoryGirl.create(:order)).to be_valid
  end
end
