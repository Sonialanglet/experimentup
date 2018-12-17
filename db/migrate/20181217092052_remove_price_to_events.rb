class RemovePriceToEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :price, :string
  end
end
