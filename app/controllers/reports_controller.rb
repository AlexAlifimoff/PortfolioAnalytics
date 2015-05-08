class ReportsController < ApplicationController
    def view
        @report = Report.find_by_id(params[:id])
    end
    
    def upload
    
    end
    def new
        @report = Report.new
    end
    def create
        stock = Stock.find_by_ticker params[:report][:stock_ticker]
        @report = Report.new(report_params(params[:report]))
        if stock && @report.save
            stock.reports << @report
            redirect_to "/display/holdings"
        else
            redirect_to "/reports/new"
        end
    end
    private
    def report_params(params)
        return params.permit(:presentation_date, :target_price, :stock_id)
    end
end
