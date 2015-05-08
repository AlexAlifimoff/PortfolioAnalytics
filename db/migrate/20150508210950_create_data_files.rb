class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.belongs_to  :report, index: true
      t.string      :filename
      t.timestamps
    end
  end
end
