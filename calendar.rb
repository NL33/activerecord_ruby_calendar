require 'bundler/setup'
Bundler.require(:default)
#require 'textacular'

#ActiveRecord::Base.extend(Textacular)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)


def welcome
  puts "Welcome to your Calendar!.\n\n"
  menu
end

def menu
  choice = nil
  until choice == 'x'
  puts "Press '1' to enter a new calendar event with a set date and time"
  puts "Press '2' to enter a todo without a set date or time"
  puts "Press '3' to add notes to an entry or a todo"
  puts "Press '4' to view your calendar"
  
  choice = gets.chomp
  case choice
  when '1'
	 create_event
  when '2'
   create to_do
  when '3'
   add_notes
  when '4'
   view_entries

  when 'x'
   puts "Good-bye!"
   exit

  else
    puts "Sorry, that wasn't a valid option."
  end
end 
end

def create_event
  puts "Please enter the title of your entry\n"
   title = gets.chomp
  puts "Please enter a description \n"
   description = gets.chomp
  puts "Please enter a location where this will occur"
    location = gets.chomp
  puts "Please enter a start date (YYYY-MM-DD [HH:MM:SS])"
    start_time = gets.chomp
  puts "Please enter an end date (YYYY-MM-DD [HH:MM:SS])"
    end_time = gets.chomp
  event = Event.new({ :title => title, :description => description, :location => location, :start_time => start_time, :end_time => end_time })
  event.save
  puts "\n Thank you. Your event has been added. You will now return to the main menu.\n\n"
  menu
end

***def to_do
  puts "Please enter the title of your to_do\n"
   title = gets.chomp
  puts "Please enter a description \n"
   description = gets.chomp
  puts "Please enter a location where this will occur"
    location = gets.chomp

end

def add_notes
end

def view_entries
  puts "\nHere you can view your calendar entries. \n"
  puts "Press '1' to view entries by date or '2' to view by name"
  choice = gets.chomp
  case choice
  when '1'
    view_by_date
  when '2'
    view_by_name
  end
end

def view_by_date
  puts "\nPlease enter the date range you wish to view:" 
  puts "Please enter the first start day for events in the range you want to view (YYYY-MM-DD). You can also specify a particular time if you like (YYYY-MM-DD HH:MM:SS)"
  entered_start_date = gets.chomp
  puts "Please enter the last start day for events in the range you want to view (YYYY-MM-DD). You can also specify a particular time if you like (YYYY-MM-DD HH:MM:SS)"
  entered_end_date = gets.chomp
  results = Event.where(start_time: entered_start_date..entered_end_date) #this searches the date range
  results.each do |result|
    puts "\n #{result.start_time} through #{result.end_time}"
    puts "  #{result.title}.  This event takes place at #{result.location}"
    puts "    #{result.description}\n\n"
  end
  puts "Press '1' to view more entries or press '2' to return to the main menu"
    choice = gets.chomp
    case choice
    when '1'
      view_entries
    when '2'
      menu 
    end
end

def view_by_name
  puts "\nPlease enter the name of the event you wish to view"
  entered_title = gets.chomp
  results = Event.where("title LIKE ?", "%#{entered_title}%") #search for titles that include the title specified
  results.each do |result|
    puts "\n #{result.start_time} through #{result.end_time}"
    puts "  #{result.title}.  This event takes place at #{result.location}"
    puts "    #{result.description}\n\n"
  end
  puts "Press '1' to view more entries or press '2' to return to the main menu"
    choice = gets.chomp
    case choice
    when '1'
      view_entries
    when '2'
      menu 
    end
end


welcome