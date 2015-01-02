class Event < ActiveRecord::Base
  validates_datetime :start_time, :presence => true #using validates_timeliness gem
  has_many :notes, as: :note_entry
end
 