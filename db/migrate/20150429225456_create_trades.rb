class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.belongs_to  :portfolio, index: true
      t.datetime    :execution_date
      t.string      :asset_ticker
      t.float       :price
      t.float       :quantity
      t.timestamps
    end
  end
end
