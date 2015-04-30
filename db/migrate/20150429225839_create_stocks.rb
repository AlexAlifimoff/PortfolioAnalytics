class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string      :ticker
      t.string      :industry_group
      t.timestamps
    end
  end
end
