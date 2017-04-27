class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates_presence_of :qty
  validates_presence_of :unit_price
  validates_presence_of :total_price

  def decorate
    {
      id: id,
      product_name: product.name,
      qty: qty,
      unit_price: unit_price,
      total_price: total_price
    }
  end
end
