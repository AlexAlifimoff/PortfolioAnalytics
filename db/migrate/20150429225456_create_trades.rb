require 'csv'

class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.belongs_to  :portfolio, index: true
      t.datetime    :execution_date
      t.string      :asset_ticker
      t.float       :price
      t.float       :quantity
      t.float       :fees
      t.timestamps
    end
    
    p = Portfolio.first
    csv = CSV.open(Rails.root.join('data', 'Trades1.csv').to_s, :headers => true).to_a.map
    csv.each do |entry|
        tr = Trade.new
        tr.execution_date = 1.year.ago
        tr.price = entry["Price"].to_f
        tr.quantity = entry["Quantity"].to_f
        tr.fees = 2.0
        tr.asset_ticker = entry["Ticker"]
        tr.save
        p.trades << tr
    end
    
    p.save
  end
end
