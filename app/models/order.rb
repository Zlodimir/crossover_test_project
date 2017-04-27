class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_lines, inverse_of: :order, dependent: :destroy

  accepts_nested_attributes_for :order_lines, reject_if: :all_blank

  validates_presence_of :order_no
  validates_presence_of :total
  validates_presence_of :date

  scope :by_date, -> { order(created_at: :desc) }

  def decorate
    {
      id: id,
      customer_id: customer_id,
      order_no: order_no,
      total: total,
      date: date,
      paid: paid,
      order_lines: order_lines.map(&:decorate)
    }
  end
end
