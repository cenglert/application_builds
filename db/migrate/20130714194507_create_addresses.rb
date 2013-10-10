class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table(:addresses,:options => "auto_increment = 1000000") do |t|
      t.string  :street_address#, :null => false
      t.string :apartment_number 
      t.string  :postal_code#, :null => false
      t.integer :city_id #, :null => false
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10
      t.references :addressable, :polymorphic => true
      t.boolean :active #, :null => false
      t.timestamps
    end
    add_index :addresses, [:latitude, :longitude]
    #add_index :addresses, :md5
  end
  
  def self.down
    drop_table :addresses
  end
end