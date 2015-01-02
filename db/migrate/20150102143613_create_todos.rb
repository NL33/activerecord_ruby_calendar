class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
    	t.string :title  #note: equivalent to: t.column :title, :string
    	t.string :description
    	t.string :location

    	t.timestamps
    end
  end
end
