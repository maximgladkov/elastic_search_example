class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :aux_data

      t.timestamps
    end
  end
end
