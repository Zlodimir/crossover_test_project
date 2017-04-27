require 'rails_helper'

# Test suite for the Order model
RSpec.describe Customer, type: :model do
  # ensure Customer model has a 1:m relationship with the Order model
  it { should have_many(:orders).dependent(:destroy) }
  
  # Validation tests
  # ensure columns email, firstname, lastname, password are present before saving
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }

  it "has a valid factory" do
    expect(FactoryGirl.create(:customer)).to be_valid
  end
end
