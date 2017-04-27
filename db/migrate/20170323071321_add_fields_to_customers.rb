class AddFieldsToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :firstname, :string, null: false, default: ''
    add_column :customers, :lastname, :string, null: false, default: ''
    remove_column :customers, :name, :string
    remove_column :customers, :nickname, :string
  end
end
