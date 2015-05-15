require 'date'
class DisplayController < ApplicationController
    @@portfolio_start_date = Date.parse('21-04-2015')
    @@portfolio_end_date = Date.yesterday
    def home
        if not logged_in?
            render "users/login"
            return
        end
        
        @active_tab = "home"
        st = @@portfolio_start_date
        et = (@@portfolio_end_date.wday == 6) ? @@portfolio_end_date - 1 : (@@portfolio_end_date.wday == 0) ? @@portfolio_end_date - 2 : @@portfolio_end_date
        portfolio = Portfolio.first
        @beta = portfolio.beta(st, et)
        daily_var = portfolio.variance(st, et)
        @var = daily_var * 255
        begin
            @value_at_risk = (daily_var ** (0.5)) * 2 * portfolio.get_value_on(et)
        rescue
            et = et - 3
            @value_at_risk = (daily_var ** (0.5)) * 2 * portfolio.get_value_on(et)
        end
        @prices = portfolio.get_prices(st, et)
        @returns = portfolio.get_returns(st, et)[0]
        @benchmark_prices = Stock.where("ticker = ?", portfolio.benchmark).first.get_prices(st, et)
        @tracking_error = portfolio.tracking_error(st, et)
    end
    def risk
        if not logged_in?
            render "users/login"
            return
        end
        portfolio = Portfolio.first
        st = @@portfolio_start_date
        today = Date.yesterday
        et = (@@portfolio_end_date.wday == 6) ? @@portfolio_end_date - 1 : (@@portfolio_end_date.wday == 0) ? @@portfolio_end_date - 2 : @@portfolio_end_date
        @active_tab = "risk"
        r_arr = portfolio.get_returns(st, et)
        @returns = r_arr[0]
        @dates = r_arr[1]
    end
    def compliance
        if not logged_in?
            render "users/login"
            return
        end
        portfolio = Portfolio.first
        st = @@portfolio_start_date
        et = (@@portfolio_end_date.wday == 6) ? @@portfolio_end_date - 1 : (@@portfolio_end_date.wday == 0) ? @@portfolio_end_date - 2 : @@portfolio_end_date
        @vals_by_sector = portfolio.get_industry_group_values(et)
        @total_value = 0
        @vals_by_sector.each do |sector, val|
            @total_value += val
        end
        @igs = ["Energy", "Materials", "Consumer Discretionary", "Consumer Staples", "Health Care", "Financials", "Information Technology", "Telecommunication Services", "Utilities"]
        @industry_weights = {
            "Energy" => 3.64,
            "Materials" => 4.38,
            "Consumer Discretionary" => 13.67,
            "Consumer Staples" => 3.09,
            "Health Care" => 15.67,
            "Financials" => 23.53,
            "Information Technology" => 18.17,
            "Telecommunication Services" => 0.74,
            "Utilities" => 3.41,
            "Industrials" => 13.50
                            }
        @threshold = 5.0
        @unbalanced_sectors = []
        @industry_weights.each do |sector, weight|
            if(@vals_by_sector[sector].nil?) then @vals_by_sector[sector] = 0 end
            if((weight - @vals_by_sector[sector]*100/@total_value).abs > 5.0)
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
        @beta_constrained = ((@beta > 0.8) and (@beta < 1.2))
        
    end
    def log
        if not logged_in?
            render "users/login"
            return
        end
        portfolio = Portfolio.first
        @trades = portfolio.trades
    end
    def holdings
        if not logged_in?
            render "users/login"
            return
        end
        time = (@@portfolio_end_date.wday == 6) ? @@portfolio_end_date - 1 : (@@portfolio_end_date.wday == 0) ? @@portfolio_end_date - 2 : @@portfolio_end_date
        portfolio = Portfolio.first
        @holdings = portfolio.get_holdings_and_prices_on(time)
        @total_value = portfolio.get_value_on(time)
        cost_arr = portfolio.get_cost_on(time)
        @total_cost = cost_arr[0] + cost_arr[1]
    end
end
