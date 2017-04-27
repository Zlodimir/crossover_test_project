class CreateCoreTables < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.text  :description, null: false
      t.string  :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0.0
      t.integer :status, null: false, default: 0
      t.timestamps
    end

    create_table :orders do |t|
      t.integer :customer_id, null: false
      t.string :order_no, null: false
      t.decimal :total, precision: 10, scale: 2, null: false, default: 0.0
      t.date :date, null: false
      t.timestamps
    end

    create_table :order_lines do |t|
      t.integer :order_id, null: false
      t.integer :product_id, null: false
      t.integer :qty, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false, default: 0.0
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0.0
    end

    add_foreign_key :orders, :customers, column: :customer_id
    add_foreign_key :order_lines, :products, column: :product_id
    add_foreign_key :order_lines, :orders, column: :order_id
  end
end
