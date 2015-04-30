class Portfolio < ActiveRecord::Base
    has_many :trades
end
