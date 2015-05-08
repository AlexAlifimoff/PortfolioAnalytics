class ReportsController < ApplicationController
    def view
        @report = Report.find_by_id(params[:id])
    end
    
    def upload
        @report = Report.find_by_id(params[:report][:id])
        uploaded_io = params[:file]
        File.open(Rails.root.join('reports', uploaded_io.original_filename), 'wb') do |file|
            file.write(uploaded_io.read)
        end
        @df = DataFile.new
        @df.filename = Rails.root.join('reports', uploaded_io.original_filename)
        if @df.save
            @report.datafiles << @df
            @report.save
            redirect_to "/reports/view/#{params[:report][:id]}"
        else 
            redirect_to "/display/holdings"
        end
    end
    def new
        @report = Report.new
    end
    def create
        stock = Stock.find_by_id params[:report][:stock_id]
        @report = Report.new(report_params(params[:report]))
        if stock && @report.save
            stock.reports << @report
            stock.save
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
