part of todo_mvc_app;

class Todos {
  DomainSession session;
  Tasks tasks;

  List<Todo> todoList = new List<Todo>();
  Element todoElements = query('#todo-list');

  Todos(this.session, this.tasks);

  Todo _find(Task task) {
    for (Todo todo in todoList) {
      if (todo.task == task) {
        return todo;
      }
    }
  }

  add(Task task) {
    var todo = new Todo(session, tasks, task);
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

  int count() {
    return todoList.length;
  }

}


