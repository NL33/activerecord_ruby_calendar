Practice app with activerecord/ruby. Users create calendar, with events/todos/notes.

Notes belong to both events (which are calendar entries with set dates/times) and also to-dos (calendar entries without dates). The notes relationship to events and todos are therefore structured as polymorphic associations.