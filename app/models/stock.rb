require 'quandl/client'



class Stock < ActiveRecord::Base
    has_many    :stock_data
    
    def get_close_price_on(date)
        if !date.kind_of? Date
            date = date.to_date
        end
        data = self.stock_data.where("date = ?", date)
        if(data.size == 0)
            self.load_data
            data = self.stock_data.where("date = ?", date)
        end
        return data.first.close
    end
    def get_prices(start_date, end_date)
        prices = []
        data = self.stock_data.where("date <= ? AND date >= ?", end_date, start_date)
        data = data.order(:date)
        data.each do |day|
            prices << day.close
        end
        return prices
    end
    def get_returns(start_date, end_date)
        start_date = start_date.to_date
        end_date = end_date.to_date
        prices = self.get_prices(start_date, end_date)
        last_price = -1
        returns = []
        prices.each do |price|
            if(last_price != -1)
                returns << (price - last_price)/last_price
            end
            last_price = price
        end
        return returns
    end
    def load_data
        Quandl::Client.use 'http://quandl.com/api'
        Quandl::Client.token = 'dxNY4n6Y35zrD46ohyzK'
        d = Quandl::Client::Dataset.find("EOD/#{self.ticker}").data
        d = d.trim_start("2015-01-01")
        d.each do |day|
            existing_data = self.stock_data.where("date = ?", day[0])
            if(existing_data.size == 0)
                sd = StockDatum.new
                sd.date = day[0]
                sd.open = day[1]
                sd.high = day[2]
                sd.low  = day[3]
                sd.close= day[4]
                sd.volume= day[5]
                sd.dividend= day[6]
                sd.split = day[7]
                sd.adj_open = day[8]
                sd.adj_high = day[9]
                sd.adj_low = day[10]
                sd.adj_close = day[11]
                sd.adj_volume = day[12]
                sd.save
                sd.stock = self
                self.stock_data << sd
            end
        end
        self.save
    end
    
end
