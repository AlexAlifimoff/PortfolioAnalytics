class DisplayController < ApplicationController
    @@portfolio_start_date = Date.parse('21-04-2015')
    def home
        @active_tab = "home"
        st = @@portfolio_start_date
        et = 1.day.ago.to_date
        portfolio = Portfolio.first
        @beta = portfolio.beta(st, et)
        daily_var = portfolio.variance(st, et)
        @var = daily_var * 255
        @value_at_risk = (daily_var ** (0.5)) * 2 * portfolio.get_value_on(et)
        @prices = portfolio.get_prices(st, et)
        @returns = portfolio.get_returns(st, et)[0]
        @benchmark_prices = Stock.where("ticker = ?", portfolio.benchmark).first.get_prices(st, et)
        @tracking_error = portfolio.tracking_error(st, et)
    end
    def risk
        portfolio = Portfolio.first
        st = @@portfolio_start_date
        et = 1.day.ago.to_date
        @active_tab = "risk"
        r_arr = portfolio.get_returns(st, et)
        @returns = r_arr[0]
        @dates = r_arr[1]
    end
    def compliance
        portfolio = Portfolio.first
        st = @@portfolio_start_date
        et = 1.day.ago.to_date
        @vals_by_sector = portfolio.get_industry_group_values(et)
        @total_value = 0
        @vals_by_sector.each do |sector, val|
            @total_value += val
        end
        @igs = ["Energy", "Materials", "Consumer Discretionary", "Consumer Staples", "Health Care", "Financials", "Information Technology", "Telecommunication Services", "Utilities"]
        @industry_weights = {
            "Energy" => 10.0,
            "Materials" => 5.0,
            "Consumer Discretionary" => 10.0,
            "Consumer Staples" => 10.0,
            "Health Care" => 10.0,
            "Financials" => 10.0,
            "Information Technology" => 10.0,
            "Telecommunication Services" => 20.0,
            "Utilities" => 15.0
                            }
        @threshold = 5.0
        @unbalanced_sectors = []
        @industry_weights.each do |sector, weight|
            if(@vals_by_sector[sector].nil?) @vals_by_sector[sector] = 0 end
            if((weight - @vals_by_sector[sector]/@total_value).abs > 5.0)
                @unbalanced_sectors << sector
            end
        end
        @holdings = portfolio.get_holdings_and_prices_on(et)
        @unbalanced_stocks = []
        @holdings.each do |ticker, holding|
            if(ticker == portfolio.benchmark) then next end
            if((holding["Quantity"] * holding["Price"]/@total_value) > 0.05)
                @unbalanced_stocks << ticker
            end
        end
        @beta = portfolio.beta(st, et)
        @beta_constrained = ((@beta > 0.9) and (@beta < 1.1))
        
    end
    def log
        portfolio = Portfolio.first
        @trades = portfolio.trades
    end
    def holdings
        time = 1.day.ago.to_date
        portfolio = Portfolio.first
        @holdings = portfolio.get_holdings_and_prices_on(time)
        @total_value = portfolio.get_value_on(time)
        cost_arr = portfolio.get_cost_on(time)
        @total_cost = cost_arr[0] + cost_arr[1]
    end
end
