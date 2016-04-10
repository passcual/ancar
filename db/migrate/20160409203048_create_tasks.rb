class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :orden
      t.text :descripcion

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
