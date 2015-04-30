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
    
    p = Portfolio.all.first
    tr1 = Trade.new
    tr1.execution_date = 1.year.ago
    tr1.asset_ticker = "AAPL"
    tr1.price = 12.2
    tr1.quantity = 100.0
    tr1.fees = 2.0
    tr1.save
    
    tr2 = Trade.new
    tr2.execution_date = 1.year.ago
    tr2.asset_ticker = "PMT"
    tr2.price = 20.12
    tr2.quantity = 50
    tr2.fees = 2.0
    tr2.save
    
    p.trades << tr1
    p.trades << tr2
    p.save
  end
end
