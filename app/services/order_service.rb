class OrderService
  def prepare(params, current_customer)
    order_lines = []
    total = 0.0

    # prepare nested order lines
    params[:order][:order_lines_attributes].each_with_index do |line|
      product = Product.find(line[:product_id])
      line_price = product.price * line[:qty].to_i
      total += line_price
      order_lines.push({ unit_price: product.price, total_price: line_price, product_id: line[:product_id], qty: line[:qty].to_i })
    end

    # prepare order
    order = { customer_id: current_customer.id, date: Time.now(), total: total, order_no: generate_number(current_customer), order_lines_attributes: order_lines }
    Order.new(order)
  end

  private

  def generate_number(user)
    "#{user.email[0].upcase}#{user.firstname[0].upcase}#{user.lastname[0].upcase}#{Time.now().to_i}"
  end
end
