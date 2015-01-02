class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
    	t.string :title  #note: this was entered in error. Migration removed this and replaced it with the column description (string)
    	t.references :note_entry, polymorphic: true  #note--this could be separated into note_entry_id (integer) and note_entry_type(string)

    	t.timestamps
    end
   end
end

