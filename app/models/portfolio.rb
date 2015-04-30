class Portfolio < ActiveRecord::Base
    has_many :trades
    
    def get_holdings_on(date)
        holdings = {}
        relevant_trades = self.trades.where("execution_date <= ?", date)
        relevant_trades.each do |trade|
            if(holdings.has_key? trade.asset_ticker)
                holdings[trade.asset_ticker]["Quantity"] += trade.quantity
                holdings[trade.asset_ticker]["Total Cost"] += trade.price * trade.quantity
                holdings[trade.asset_ticker]["Fees"] += trade.fees
            else
                holdings[trade.asset_ticker] = {}
                holdings[trade.asset_ticker]["Quantity"] = trade.quantity
                holdings[trade.asset_ticker]["Total Cost"] = trade.price * trade.quantity
                holdings[trade.asset_ticker]["Fees"] = trade.fees
            end
        end
        return holdings
    end
    
    def get_value_on(date)
        holdings = self.get_holdings_on(date)
        total_value = 0
        total_cost = 0
        holdings.each do |ticker, holding|
            stock = Stock.where("ticker = ?", ticker).first
            if(stock.nil?)
                stock = Stock.new
                stock.ticker = ticker
                stock.load_data
                stock.save
            end
            total_value += holding["Quantity"] * stock.get_close_price_on(date.to_date)
            total_cost += holding["Total Cost"] + holding["Fees"]
        end
        cash = self.initial_cash - total_cost
        return total_value + cash
    end
    
    
    def get_prices(start_date, end_date)
        prices = []
        while(start_date <= end_date)
            wday = start_date.wday
            if wday != 0 and wday != 6
                prices << self.get_value_on(start_date)
            end
        start_date = start_date.tomorrow
        end
        return prices
    end
end
