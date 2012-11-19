part of todo_mvc_app;

class TodoApp implements ActionReactionApi, PastReactionApi {
  DomainSession session;
  Tasks tasks;

  Todos todos;
  Element main = query('#main');
  Element completeAll = query('#complete-all');
  Element footer = query('#footer');
  Element leftCount = query('#left-count');
  Element clearCompleted = query('#clear-completed');
  Element undo = query('#undo');
  Element redo = query('#redo');
  Element errors = query('#errors');

  TodoApp(TodoModels domain) {
    session = domain.newSession();
    domain.startActionReaction(this);
    session.past.startPastReaction(this);
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = model.getEntry('Task');

    todos = new Todos(this);
    //load todos
    String json = window.localStorage['todos'];
    if (json != null) {
      var todoList = JSON.parse(json);
      tasks.fromJson(json);
      for (Task task in tasks) {
        todos.add(task);
      }
      _updateFooter();
      _possibleErrors();
    }

    Element newTodo = query('#new-todo');
    newTodo.on.keyPress.add((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          newTodo.value = '';
          new AddAction(session, tasks, task).doit();
          _possibleErrors();
        }
      }
    });

    completeAll.on.click.add((Event e) {
      if (tasks.left.length == 0) {
        for (Task task in tasks) {
          new SetAttributeAction(session, task, 'completed', false).doit();
        }
      } else {
        for (Task task in tasks.left) {
          new SetAttributeAction(session, task, 'completed', true).doit();
        }
      }
    });

    clearCompleted.on.click.add((MouseEvent e) {
      for (Task task in tasks.completed) {
        new RemoveAction(session, tasks.completed, task).doit();
      }
    });

    undo.style.display = 'none';
    undo.on.click.add((MouseEvent e) {
      session.past.undo();
    });

    redo.style.display = 'none';
    redo.on.click.add((MouseEvent e) {
      session.past.redo();
    });
  }

  _possibleErrors() {
    errors.innerHTML = tasks.errors.toString();
    tasks.errors.clear();
  }

  _save() {
    window.localStorage['todos'] = JSON.stringify(tasks.toJson());
  }

  _updateFooter() {
    var display = tasks.count == 0 ? 'none' : 'block';
    completeAll.style.display = display;
    main.style.display = display;
    footer.style.display = display;

    // update counts
    var completedLength = tasks.completed.length;
    var leftLength = tasks.left.length;
    completeAll.checked = (completedLength == tasks.length);
    leftCount.innerHTML =
        '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
    if (completedLength == 0) {
      clearCompleted.style.display = 'none';
    } else {
      clearCompleted.style.display = 'block';
      clearCompleted.text = 'Clear completed (${tasks.completed.length})';
    }
  }

  react(BasicAction action) {
    if (action is AddAction) {
      if (action.state == 'undone') {
        todos.remove(action.entity);
      } else {
        todos.add(action.entity);
      }
    } else if (action is RemoveAction) {
      if (action.state == 'undone') {
        todos.add(action.entity);
      } else {
        todos.remove(action.entity);
      }
    } else if (action is SetAttributeAction) {
      if (action.property == 'completed') {
        todos.complete(action.entity);
      } else if (action.property == 'title') {
        todos.retitle(action.entity);
      }
    }
    _updateFooter();
    _save();
  }

  reactCannotUndo() {
    undo.style.display = 'none';
  }

  reactCanUndo() {
    undo.style.display = 'block';
  }

  reactCanRedo() {
    redo.style.display = 'block';
  }

  reactCannotRedo() {
    redo.style.display = 'none';
  }

}

