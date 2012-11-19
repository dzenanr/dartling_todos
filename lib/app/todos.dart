part of todo_mvc_app;

class Todos {
  TodoApp todoApp;
  DomainSession session;
  Tasks tasks;

  List<Todo> todoList = new List<Todo>();
  Element todoElements = query('#todo-list');
  Element allElements = query('#filters a[href="#/"]');
  Element leftElements = query('#filters a[href="#/left"]');
  Element completedElements = query('#filters a[href="#/completed"]');

  Todos(this.todoApp) {
    session = todoApp.session;
    tasks = todoApp.tasks;
    window.on.hashChange.add((e) => updateFilter());
  }

  Todo _find(Task task) {
    for (Todo todo in todoList) {
      if (todo.task == task) {
        return todo;
      }
    }
  }

  add(Task task) {
    var todo = new Todo(todoApp, task);
    todoList.add(todo);
    todoElements.nodes.add(todo.create());
  }

  remove(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todoList.removeAt(todoList.indexOf(todo));
      todo.remove();
    }
  }

  complete(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.complete(task.completed);
    }
  }

  retitle(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.retitle(task.title);
    }
  }

  updateFilter() {
    switch(window.location.hash) {
      case '#/left':
        showLeft();
        break;
      case '#/completed':
        showCompleted();
        break;
      default:
        showAll();
    }
  }

  showAll() {
    _setSelectedFilter(allElements);
    for (Todo todo in todoList) {
      todo.visible = true;
    }
  }

  showLeft() {
    _setSelectedFilter(leftElements);
    for (Todo todo in todoList) {
      todo.visible = todo.task.left;
    }
  }

  void showCompleted() {
    _setSelectedFilter(completedElements);
    for (Todo todo in todoList) {
      todo.visible = todo.task.completed;
    }
  }

  _setSelectedFilter(Element e) {
    allElements.classes.remove('selected');
    leftElements.classes.remove('selected');
    completedElements.classes.remove('selected');
    e.classes.add('selected');
  }

}


