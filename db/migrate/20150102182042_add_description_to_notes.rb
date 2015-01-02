class AddDescriptionToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :description, :string
  end
end
