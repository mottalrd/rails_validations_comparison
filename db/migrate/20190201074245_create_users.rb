class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :email
      t.integer :age
      t.boolean :marketing_opt_in

      t.timestamps
    end
  end
end
