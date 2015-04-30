require 'quandl/client'



class Stock < ActiveRecord::Base
    has_many    :stock_data
    
    def get_close_price_on(date)
        data = self.stock_data.where("date = ?", date)
        if(data.size == 0)
            self.load_data
            data = self.stock_data.where("date = ?", date)
        end
        return data.first.close
    end
    def load_data
        Quandl::Client.use 'http://quandl.com/api'
        Quandl::Client.token = 'dxNY4n6Y35zrD46ohyzK'
        d = Quandl::Client::Dataset.find("EOD/#{self.ticker}").data
        d = d.trim_start("2015-03-31")
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
