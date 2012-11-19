part of todo_mvc_app;

class Todo {
  TodoApp todoApp;
  DomainSession session;
  Tasks tasks;
  Task task;

  Element todo;
  Element completed;
  Element title;

  Todo(this.todoApp, this.task) {
    session = todoApp.session;
    tasks = todoApp.tasks;
  }

  Element create() {
    todo = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='completed' type='checkbox' ${task.completed ? 'checked' : ''}>
          <label id='title'>${task.title}</label>
          <button class='remove'></button>
        </div>
        <input class='edit' value='${task.title}'>
      </li>
    ''');

    title = todo.query('#title');
    Element edit = todo.query('.edit');

    title.on.doubleClick.add((MouseEvent e) {
      todo.classes.add('editing');
      edit.select();
    });

    edit.on.keyPress.add((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = edit.value.trim();
        if (title != '') {
          var action = new SetAttributeAction(
              session, task, 'title', title);
          action.doit();
        }
      }
    });

    completed = todo.query('.completed');
    completed.on.click.add((MouseEvent e) {
      var action = new SetAttributeAction(
          session, task, 'completed', !task.completed);
      action.doit();
    });

    todo.query('.remove').on.click.add((MouseEvent e) {
      var action = new RemoveAction(session, tasks, task);
      action.doit();
    });

    return todo;
  }

  remove() {
    todo.remove();
  }

  complete(bool newCompleted) {
    completed.checked = newCompleted;
    if (newCompleted) {
      todo.classes.add('completed');
    } else {
      todo.classes.remove('completed');
    }
  }

  retitle(String newTitle) {
    title.text = newTitle;
    todo.classes.remove('editing');
  }

  set visible(bool visible) {
    todo.style.display = visible ? 'block' : 'none';
  }

}
