class AddOutToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :out, :boolean, default: false
  end
end
