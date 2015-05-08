class Report < ActiveRecord::Base
    belongs_to :stock
    has_many   :data_files
end
