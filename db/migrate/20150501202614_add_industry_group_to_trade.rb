require 'date'
class AddIndustryGroupToTrade < ActiveRecord::Migration
  def change
  	add_column :trades, :industry_group, :string
    
    Trade.reset_column_information
    
    p = Portfolio.first
    seeddata = ["seedtrades1.csv", "seedtrades2.csv"]
    seeddata.each do |file|
        csv = CSV.open(Rails.root.join('data', file).to_s, :headers => true, :encoding => 'windows-1251:utf-8').to_a.map
        csv.each do |entry|
            tr = Trade.new
            tr.execution_date = Date.strptime(entry["Trade Date"], "%m/%d/%Y")
            tr.price = entry["Price"].to_f
            tr.quantity = entry["Quantity"].to_f
            tr.fees = entry["Fees"].to_f
            if(entry["Ticker"] == "MOG.A") then entry["Ticker"] = "MOG_A" end
            tr.asset_ticker = entry["Ticker"]
            s = Stock.new
            s.ticker = entry["Ticker"]
            s.industry_group = entry["Industry Group"]
            #s.load_data
            s.save
            tr.save
            p.trades << tr
        end
    end
  end
end
