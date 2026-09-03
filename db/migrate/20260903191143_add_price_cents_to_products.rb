class AddPriceCentsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :price_cents, :integer
  end
end
