require 'descriptive_statistics'
require 'statsample'

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
    
    def get_industry_group_values(date)
        holdings = Rails.cache.fetch("holdings/#{self.name}/#{date.to_date}", expires_in: 12.hours) do self.get_holdings_on(date) end
        igs = ["Energy", "Materials", "Consumer Discretionary", "Consumer Staples", "Health Care", "Financials", "Information Technology", "Telecommunication Services", "Utilities"]
        ig_values = {}
        holdings.each do |ticker, holding|
            stock = Stock.where("ticker = ?", ticker).first
            if(ticker == self.benchmark) then next end
            if(ig_values.has_key? stock.industry_group)
                ig_values[stock.industry_group] += stock.get_close_price_on(date.to_date) * holding["Quantity"]
            else
                ig_values[stock.industry_group] = stock.get_close_price_on(date.to_date) * holding["Quantity"]
            end
        end
        return ig_values
    end
    
    def get_holdings_and_prices_on(date)
        holdings = Rails.cache.fetch("holdings/#{self.name}/#{date.to_date}", expires_in: 12.hours) do self.get_holdings_on(date) end
        holdings.each do |ticker, holding|
            stock = Stock.where("ticker = ?", ticker).first
            holdings[ticker]["Price"] = stock.get_close_price_on(date.to_date)
        end
        return holdings
    end
    
    def get_value_on(date)
        holdings = Rails.cache.fetch("holdings/#{self.name}/#{date.to_date}", expires_in: 12.hours) do self.get_holdings_on(date) end
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
    
    ## Returns the as an array with [total_cost, total_fees]
    def get_cost_on(date)
        holdings = Rails.cache.fetch("holdings/#{self.name}/#{date.to_date}", expires_in: 12.hours) do self.get_holdings_on(date) end
        total_cost = 0
        total_fees = 0
        holdings.each do |ticker, holding|
            total_cost += holding["Total Cost"]
            total_fees += holding["Fees"]
        end
        return [total_cost, total_fees]
    end
    
    
    def get_prices(start_date, end_date)
        prices = []
        dates = []
        while(start_date <= end_date)
            wday = start_date.wday
            if wday != 0 and wday != 6
                begin
                    value = Rails.cache.fetch("port_val/#{self.name}/#{start_date.to_date}", expires_in: 12.hours) do self.get_value_on(start_date) end
                    prices << value
                    dates << start_date.to_date
                rescue NoMethodError
                    # We do this because I am lazy and don't want to figure out more pricely
                    # If the markets were open...
                    # Note to future self: you should probably fix this.
                end
                
            end
        start_date = start_date.tomorrow
        end
        return [prices, dates]
    end
    
    def get_returns(start_date, end_date)
        prices = self.get_prices(start_date, end_date)[0]
        last_price = -1
        returns = []
        dates = []
        prices.each do |price|
            if(last_price != -1)
                returns << (price - last_price)/last_price
                dates << start_date.to_date
            end
            start_date = start_date.tomorrow
            last_price = price
        end
        return [returns, dates]
    end
    
    def variance(start_date, end_date)
        prices = self.get_returns(start_date, end_date)[0]
        return prices.variance
    end
    
    def covariance(start_date, end_date)
        portfolio_returns = self.get_returns(start_date, end_date)[0]
        benchmark_returns = Stock.where("ticker = ?", self.benchmark).first.get_returns(start_date, end_date)
        p_avg = portfolio_returns.mean
        b_avg = benchmark_returns.mean
        sum = 0
        portfolio_returns.zip(benchmark_returns).each do |portfolio, benchmark|
            sum += (portfolio - p_avg)*(benchmark - b_avg)
        end
        return (sum / (portfolio_returns.size - 1))
    end
    
    def beta(start_date, end_date)
        benchmark_returns = Stock.where("ticker = ?", self.benchmark).first.get_returns(start_date, end_date)
        return self.covariance(start_date, end_date) / benchmark_returns.variance
    end
    
    def tracking_error(start_date, end_date)
        benchmark_returns = Stock.where("ticker = ?", self.benchmark).first.get_returns(start_date, end_date)
        portfolio_returns = self.get_returns(start_date, end_date)[0]
        diff_in_returns = []
        portfolio_returns.zip(benchmark_returns).each do |portfolio, benchmark|
            diff_in_returns << (portfolio - benchmark)
        end
        return diff_in_returns.standard_deviation
    end
end
