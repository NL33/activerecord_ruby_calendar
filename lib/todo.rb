class Todo < ActiveRecord::Base
  has_many :notes, as: :note_entry
end