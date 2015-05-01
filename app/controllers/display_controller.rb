class DisplayController < ApplicationController
    def home
        @active_tab = "home"
        st = 3.months.ago.to_date
        et = 8.hours.ago.to_date
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
        st = 3.months.ago.to_date
        et = 8.hours.ago.to_date
        @active_tab = "risk"
        r_arr = portfolio.get_returns(st, et)
        @returns = r_arr[0]
        @dates = r_arr[1]
    end
    def log
        portfolio = Portfolio.first
        @trades = portfolio.trades
    end
    def holdings
        time = 8.hours.ago.to_date
        portfolio = Portfolio.first
        @holdings = portfolio.get_holdings_and_prices_on(time)
        @total_value = portfolio.get_value_on(time)
        cost_arr = portfolio.get_cost_on(time)
        @total_cost = cost_arr[0] + cost_arr[1]
    end
end
