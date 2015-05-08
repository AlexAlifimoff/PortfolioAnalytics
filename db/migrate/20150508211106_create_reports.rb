class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.belongs_to  :stock, index: true
      t.float       :target_price
      t.date        :presentation_date
      t.timestamps
    end
  end
end
