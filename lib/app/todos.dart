part of todo_mvc_app;

class Todos {
  List<Todo> todoList = new List<Todo>();
  Element todoElements = query('#todo-list');

  add(Todo todo) {
    todoList.add(todo);
    todoElements.nodes.add(todo.create());
  }

  remove(Todo todo) {
    todoList.removeAt(todoList.indexOf(todo));
    todo.remove();
  }

  Iterator<Todo> iterator() => todoList.iterator();

  int count() {
    return todoList.length;
  }

}


