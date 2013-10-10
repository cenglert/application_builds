class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.references :country, :null => false
      t.references :region, :null => false
      t.string :city
      t.float :latitude
      t.float :longitude
      t.string :timezone
      t.integer :dma_id
      t.string :county
      t.string :code

      t.timestamps
    end
    add_index :cities, :city  
    add_index :cities, [:region_id, :country_id]
    add_index :cities, [:latitude, :longitude]
  end    

  def self.down
    drop_table :cities
  end
end