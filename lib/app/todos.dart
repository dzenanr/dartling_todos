part of todo_mvc_app;

class Todos {
  Tasks tasks;
  List<Todo> todos = new List<Todo>();

  Element main = query('#main');
  Element allCompleted = query('#toggle-all-completed');
  Element todoList = query('#todo-list');
  Element footer = query('#footer');
  Element leftCount = query('#left-count');
  Element clearCompleted = query('#clear-completed');

  Todos(this.tasks) {
    load();

    Element newTodo = query('#new-todo');
    newTodo.on.keyPress.add((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          add(task);
          newTodo.value = '';
          updateFooter();
        }
      }
    });

    allCompleted.on.click.add((Event e) {
      InputElement target = e.srcElement;
      for (Todo todo in todos) {
        if (todo.task.completed != target.checked) {
          todo.toggleCompleted();
        }
      }
      updateCounts();
    });

    clearCompleted.on.click.add((MouseEvent e) {
      var completedTodos = new List<Todo>();
      var leftTodos = new List<Todo>();
      for (Todo todo in todos) {
        if (todo.task.completed) {
          completedTodos.add(todo);
        } else {
          leftTodos.add(todo);
        }
      }
      for (Todo completedTodo in completedTodos) {
        remove(completedTodo);
        todos.removeAt(todos.indexOf(completedTodo));
      }
      todos = leftTodos;
      updateFooter();
    });

    updateFooter();
  }

  load() {
    var json = window.localStorage['todos'];
    if (json != null) {
      try {
        var todoList = JSON.parse(json);
        for (Map todo in todoList) {
          var task = new Task(tasks.concept);
          task.fromJson(todo);
          add(task);
        }
      } catch (e) {
        window.console.log('Could not load todos from the local storage. ${e}');
      }
    }
  }

  save() {
    window.localStorage['todos'] = JSON.stringify(tasks.toJson());
  }

  add(Task task) {
    tasks.add(task);
    var todo = new Todo(task, this);
    todos.add(todo);
    todoList.nodes.add(todo.create());
  }

  remove(Todo todo) {
    var task = todo.task;
    tasks.remove(task);
    todo.remove();
    updateFooter();
  }

  updateFooter() {
    var display = todos.length == 0 ? 'none' : 'block';
    main.style.display = display;
    footer.style.display = display;
    updateCounts();
  }

  updateCounts() {
    allCompleted.checked = (tasks.completed == tasks.count);
    leftCount.innerHTML =
        '<b>${tasks.left}</b> todo${tasks.left != 1 ? 's' : ''} left';
    if (tasks.completed == 0) {
          clearCompleted.style.display = 'none';
    } else {
      clearCompleted.style.display = 'block';
      clearCompleted.text = 'Clear completed (${tasks.completed})';
    }
    save();
  }

}
