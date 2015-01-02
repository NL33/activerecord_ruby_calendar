require 'bundler/setup'
Bundler.require(:default)
require 'textacular'

ActiveRecord::Base.extend(Textacular)

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
  puts "Press '3' to add notes to an event or a todo"
  puts "Press '4' to view items in your calendar"
  puts "Press '5' to search your calendar for any terms"
  puts "Press 'x' to exit \n"
  
  choice = gets.chomp
  case choice
  when '1'
	 create_event
  when '2'
   create_todo
  when '3'
   add_notes
  when '4'
   view_entries
  when '5'
    search
  when 'x'
   puts "Good-bye!"
   exit

  else
    puts "Sorry, that wasn't a valid option."
  end
end 
end

def create_event
  puts "Please enter the title of your event\n"
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
   if !event.save 
      puts "Your event seems to be missing a start time. Please try again."
      create_event
  else
      event.save
  end
  puts "\n Thank you. Your event has been added. You will now return to the main menu.\n\n"
  menu
end

def create_todo
  puts "Please enter the title of your todo\n"
   title = gets.chomp
  puts "Please enter a description \n"
   description = gets.chomp
  puts "Please enter a location where this will occur"
    location = gets.chomp
  todo = Todo.new({ :title => title, :description => description, :location => location })
  todo.save
  puts "\n Thank you. Your todo has been added. You will now return to the main menu.\n\n"
  menu
end

def add_notes
  puts "Please enter the title of the event or todo to which you want to add notes"
  entered_title = gets.chomp
  puts "\nThe following entries match your search criteria:"
    event_results = Event.where("title LIKE ?", "%#{entered_title}%") #search for titles that include the title specified
    event_results.each do |event_result|
      puts "\n ID: #{event_result.id}"
      puts "  Event: #{event_result.start_time} through #{event_result.end_time}"
      puts "  #{event_result.title}.  This event takes place at #{event_result.location}"
      puts "    #{event_result.description}\n\n"
    end
    todo_results = Todo.where("title LIKE ?", "%#{entered_title}%") #search for titles that include the title specified
    todo_results.each do |todo_result|
      puts "\n ID: #{todo_result.id}"
      puts "  ToDo: #{todo_result.title}.  This todo takes place at #{todo_result.location}"
      puts "    #{todo_result.description}\n\n"
    end
  puts "\nWould you like to add notes to an event (enter '1') or a todo (enter '2')?"
   type = gets.chomp 
   if type == '1'
      puts "\nPlease enter the ID of the event you wish to update"
      id = gets.chomp
      event = Event.where(:id => id).first
      puts "You have selected the event titled '#{event.title}'\n"
      puts "Please enter the notes you wish to add"
      event.notes.create(description: gets.chomp)
      puts "\nThank you. Your notes have been added."
   elsif type == '2'
      puts "\nPlease enter the ID of the todo you wish to update"
      todo = Todo.where(:id => id).first
      puts "You have selected the todo titled '#{todo.title}'\n"
      puts "Please enter the notes you wish to add"
      todo.notes.create(description: gets.chomp) 
      puts "\nThank you. Your notes have been added."
   end
  puts "Press '1' to add more notes or press '2' to return to the main menu"
    choice = gets.chomp
    case choice
    when '1'
      add_notes
    when '2'
      menu 
    end
end

def view_entries
  puts "\nHere you can view your calendar entries. \n"
  puts "Press '1' to view events by date or '2' to events and todos view by name"
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
    puts "    #{result.description}"
    puts "    Notes (if any):"
    result.notes.each {|note| puts "    #{note.description}"}
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
  puts "\nPlease enter the name of the event or todo you wish to view"
  entered_title = gets.chomp
  event_results = Event.where("title LIKE ?", "%#{entered_title}%") #search for titles that include the title specified
  event_results.each do |event_result|
    puts "\n Event: #{event_result.start_time} through #{event_result.end_time}"
    puts "  #{event_result.title}.  This event takes place at #{event_result.location}"
    puts "    #{event_result.description}"
    puts "    Notes (if any):"
    event_result.notes.each {|note| puts "    #{note.description}"}
  end
  todo_results = Todo.where("title LIKE ?", "%#{entered_title}%") #search for titles that include the title specified
  todo_results.each do |todo_result|
    puts "  \nToDo: #{todo_result.title}.  This todo takes place at #{todo_result.location}"
    puts "    #{todo_result.description}"
    puts "    Notes (if any):"
    result.notes.each {|note| puts "    #{note.description}"}
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

def search  
  puts "Enter the term you are searching for"
  search_term = gets.chomp
  puts "Here are the results of your search:"
  Event.basic_search(search_term).each do |event_result|
    puts "\n Event: #{event_result.start_time} through #{event_result.end_time}"
    puts "  #{event_result.title}.  This event takes place at #{event_result.location}"
    puts "    #{event_result.description}"
    puts "    Notes (if any):"
    event_result.notes.each {|note| puts "    #{note.description}"}
  end
  Todo.basic_search(search_term).each do |todo_result|
    puts "  \nToDo: #{todo_result.title}.  This todo takes place at #{todo_result.location}"
    puts "    #{todo_result.description}"
    puts "    Notes (if any):"
    result.notes.each {|note| puts "    #{note.description}"}
  end
  puts "Press '1' to search again or press '2' to return to the main menu"
    choice = gets.chomp
    case choice
    when '1'
      search
    when '2'
      menu 
    end
end

welcome