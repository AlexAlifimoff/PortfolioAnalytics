class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string          :name
      t.float           :initial_cash
      t.string          :benchmark
      t.timestamps
    end
    
    p = Portfolio.new
    p.name = "Cardinal Fund Portfolio"
    p.initial_cash = 1000000
    p.benchmark = "IWM"
    p.save
  end
end
