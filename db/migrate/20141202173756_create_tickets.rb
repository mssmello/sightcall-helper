class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string :key
      t.string :uid
      t.string :displayname
      t.string :skill
      t.boolean :served

      t.timestamps
    end
  end
end
