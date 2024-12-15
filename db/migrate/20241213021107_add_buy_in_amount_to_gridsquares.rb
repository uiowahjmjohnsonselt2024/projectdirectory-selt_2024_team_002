class AddBuyInAmountToGridsquares < ActiveRecord::Migration[7.1]
  def change
    add_column :gridsquares, :buy_in_amount, :integer
  end
end
