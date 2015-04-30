class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string          :name
      t.float           :initial_cash
      t.timestamps
    end
    
    p = Portfolio.new
    p.name = "Cardinal Fund Portfolio"
    p.initial_cash = 1000000
    p.save
  end
end
