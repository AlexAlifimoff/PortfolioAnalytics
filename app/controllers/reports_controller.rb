class ReportsController < ApplicationController
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
    def report_params
        return params.permit(:presentation_date, :target_price)
    end
end
