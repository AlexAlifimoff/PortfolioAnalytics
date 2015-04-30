class CreateStockData < ActiveRecord::Migration
  def change
    create_table :stock_data do |t|
      t.date        :date
      t.belongs_to  :stock, index: true
      t.float       :open
      t.float       :close
      t.integer     :volume
      t.float       :high
      t.float       :low
      t.float       :dividend
      t.float       :split 
      t.float       :adj_open
      t.float       :adj_high
      t.float       :adj_low
      t.float       :adj_close
      t.float       :adj_volume
      t.timestamps
    end
  end
end
