class Product < ApplicationRecord
  has_many :order_lines, dependent: :destroy

  PRODUCT_STATUSES = {
    enabled: 0,
    disabled: 1
  }

  validates_presence_of :name
  validates_presence_of :price
  validates_presence_of :description
  validates :status,    inclusion: { in: PRODUCT_STATUSES.values }, presence: true

  scope :enabled,  -> { where(status: PRODUCT_STATUSES[:enabled]) }
  scope :disabled, -> { where(status: PRODUCT_STATUSES[:disabled]) }
end
