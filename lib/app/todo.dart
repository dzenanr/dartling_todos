part of todo_mvc_app;

class Todo {
  Task task;

  DomainSession _session;
  Tasks _tasks;

  Element _todo;
  InputElement _completed;
  Element _title;

  Todo(TodoApp todoApp, this.task) {
    _session = todoApp.session;
    _tasks = todoApp.tasks;
  }

  Element create() {
    _todo = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='completed' type='checkbox'
            ${task.completed ? 'checked' : ''}>
          <label id='title'>${task.title}</label>
          <button class='remove'></button>
        </div>
        <input class='edit' value='${task.title}'>
      </li>
    ''');

    _title = _todo.query('#title');
    InputElement edit = _todo.query('.edit');

    _title.on.doubleClick.add((MouseEvent e) {
      _todo.classes.add('editing');
      edit.select();
    });

    edit.on.keyPress.add((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var value = edit.value.trim();
        if (value != '') {
          new SetAttributeAction(_session, task, 'title', value).doit();
        }
      }
    });

    _completed = _todo.query('.completed');
    _completed.on.click.add((MouseEvent e) {
      new SetAttributeAction(_session, task, 'completed',
          !task.completed).doit();
    });

    _todo.query('.remove').on.click.add((MouseEvent e) {
      var action = new RemoveAction(_session, _tasks, task).doit();
    });

    return _todo;
  }

  remove() {
    _todo.remove();
  }

  complete(bool newCompleted) {
    _completed.checked = newCompleted;
    if (newCompleted) {
      _todo.classes.add('completed');
    } else {
      _todo.classes.remove('completed');
    }
  }

  retitle(String newTitle) {
    _title.text = newTitle;
    _todo.classes.remove('editing');
  }

  set visible(bool visible) {
    _todo.style.display = visible ? 'block' : 'none';
  }

}
