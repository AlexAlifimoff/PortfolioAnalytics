class AddIndustryGroupToTrade < ActiveRecord::Migration
  def change
  	add_column :trades, :industry_group, :string
    
    x = Stock.all
    igs = ["Energy", "Materials", "Consumer Discretionary", "Consumer Staples", "Health Care", "Financials", "Information Technology", "Telecommunication Services", "Utilities"]
    x.each do |stock|
        stock.industry_group = igs.sample
        stock.save
    end
  end
end
