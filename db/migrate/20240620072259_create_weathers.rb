class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :weathers do |t|
      t.string :location
      t.string :date
      t.string :temperature
      t.string :wind
      t.string :humidity
      t.string :condition
      t.string :url_img

      t.timestamps
    end
  end
end
