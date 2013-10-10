class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.references :country, :null => false
      t.string :region
      t.string :code
      t.string :adm1code

      t.timestamps
    end
    add_index :regions, [:country_id, :region, :code]
  end

  def self.down
    drop_table :regions
  end
end
