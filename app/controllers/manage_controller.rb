class ManageController < ApplicationController
    def add_transaction
        @trade = Trade.new
    end
    
    def create
        @trade = Trade.new(trade_params(params[:trade]))
        if @trade.save then
            Portfolio.first.trades << @trade
            redirect_to '/display/log'
        else
            render '/manage/add_transaction'
        end
    end
    
    private
    def trade_params(params)
        return params.permit(:asset_ticker, :execution_date, :price, :quantity, :fees)
    end
end
