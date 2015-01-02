Practice app with activerecord/ruby. Users create calendar, with events (which have date/times) and todos(which are not linked to specific date/times). Users can also add notes to events or todos, and also search their calendar for entries. Searching is done by looking for certain entry titles or full text searches (using the textacular gem).

The notes model/class belongs to both events and also todos. The notes relationship to events and todos are therefore structured as polymorphic associations.
