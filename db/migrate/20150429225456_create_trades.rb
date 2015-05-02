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
    
    #p = Portfolio.first
    #seeddata = ["seedtrades1.csv", "seedtrades2.csv"]
    #seeddate.each do |file|
    #    csv = CSV.open(Rails.root.join('data', file).to_s, :headers => true).to_a.map
    #    csv.each do |entry|
    #        tr = Trade.new
    #        tr.execution_date = 1.year.ago
    #        tr.price = entry["Price"].to_f
    #        tr.quantity = entry["Quantity"].to_f
    #        tr.fees = 2.0
    #        if(entry["Ticker"] == "MOG.A") then entry["Ticker"] = "MOG_A" end
    #        tr.asset_ticker = entry["Ticker"]
    #        tr.save
    #        p.trades << tr
    #    end
    #end
    
    #p.save
  end
end
