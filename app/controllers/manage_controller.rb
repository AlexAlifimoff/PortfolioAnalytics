class ManageController < ApplicationController
    def add_transaction
        if not logged_in?
            render "users/login"
            return
        end
        @trade = Trade.new
        @igs = ["Energy", "Materials", "Consumer Discretionary", "Consumer Staples", "Health Care", "Financials", "Information Technology", "Telecommunication Services", "Utilities"]
    end
    
    def delete_transaction
        if not logged_in?
            render "users/login"
            return
        end
        @trades = Portfolio.first.trades
    end
    
    def remove
        @trade = Trade.find(params[:trade][:trade_id])
        @trade.delete
        render "display/log"
    end
    
    def create
        if not logged_in?
            render "users/login"
            return
        end
        @trade = Trade.new(trade_params(params[:trade]))
        if @trade.save then
            Portfolio.first.trades << @trade
            s = Stock.where("industry_group = ?", @trade.industry_group).first
            if s.nil? then
                s = Stock.new
                s.ticker = @trade.asset_ticker
                s.industry_group = @trade.industry_group
                s.save
            end
            redirect_to '/display/log'
        else
            render '/manage/add_transaction'
        end
    end
    
    private
    def trade_params(params)
        return params.permit(:asset_ticker, :execution_date, :price, :quantity, :fees, :industry_group)
    end
end
