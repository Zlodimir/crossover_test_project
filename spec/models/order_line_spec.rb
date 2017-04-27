require 'rails_helper'

# Test suite for the OrderLine model
RSpec.describe OrderLine, type: :model do
  # ensure Order model belongs to Product model
  it { should belong_to(:product) }
  # ensure Order model belongs to Order model
  it { should belong_to(:order) }

  # Validation tests
  # ensure columns qty, unit_price, total_price are present before saving
  it { should validate_presence_of(:qty) }
  it { should validate_presence_of(:unit_price) }
  it { should validate_presence_of(:total_price) }

  it "has a valid factory" do
    expect(FactoryGirl.create(:order_line)).to be_valid
  end
end
