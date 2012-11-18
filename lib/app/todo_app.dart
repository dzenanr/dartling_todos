part of todo_mvc_app;

class TodoApp implements ActionReactionApi {
  Tasks tasks;

  Todos todos;
  Element main = query('#main');
  Element completeAll = query('#complete-all');
  Element footer = query('#footer');
  Element leftCount = query('#left-count');
  Element clearCompleted = query('#clear-completed');

  TodoApp(TodoModels domain) {
    DomainSession session = domain.newSession();
    domain.startActionReaction(this);
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = model.getEntry('Task');

    todos = new Todos(session, tasks);
    //load todos
    String json = window.localStorage['todos'];
    if (json != null) {
      var todoList = JSON.parse(json);
      tasks.fromJson(json);
      for (Task task in tasks) {
        todos.add(task);
      }
      _updateFooter();
    }

    Element newTodo = query('#new-todo');
    newTodo.on.keyPress.add((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          newTodo.value = '';
          var action = new AddAction(session, tasks, task);
          action.doit();
        }
      }
    });

    completeAll.on.click.add((Event e) {
      if (tasks.left.length == 0) {
        for (Task task in tasks) {
          var action = new SetAttributeAction(
              session, task, 'completed', false);
          action.doit();
        }
      } else {
        for (Task task in tasks.left) {
          var action = new SetAttributeAction(
              session, task, 'completed', true);
          action.doit();
        }
      }
    });

    clearCompleted.on.click.add((MouseEvent e) {
      for (Task task in tasks.completed) {
        var action = new RemoveAction(session, tasks.completed, task);
        action.doit();
      }
    });
  }

  _save() {
    window.localStorage['todos'] = JSON.stringify(tasks.toJson());
  }

  _updateFooter() {
    var display = todos.count == 0 ? 'none' : 'block';
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
      todos.add(action.entity);
    } else if (action is RemoveAction) {
      todos.remove(action.entity);
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

}

