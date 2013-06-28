part of todo_mvc_app;

class Todo {
  DomainSession _session;
  Task _task;
  Tasks _tasks;

  Element _todo;
  InputElement _completed;
  Element _title;

  Todo(TodoApp todoApp, this._task) {
    _session = todoApp.session;
    _tasks = todoApp.tasks;
  }

  Element create() {
    _todo = new Element.html('''
      <li ${_task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='completed' type='checkbox'
            ${_task.completed ? 'checked' : ''}>
          <label id='title'>${_task.title}</label>
          <button class='remove'></button>
        </div>
        <input class='edit' value='${_task.title}'>
      </li>
    ''');

    _title = _todo.query('#title');
    InputElement edit = _todo.query('.edit');

    _title.onDoubleClick.listen((MouseEvent e) {
      _todo.classes.add('editing');
      edit.select();
    });

    edit.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var value = edit.value.trim();
        if (value != '') {
          new SetAttributeAction(_session, _task, 'title', value).doit();
        }
      }
    });

    _completed = _todo.query('.completed');
    _completed.onClick.listen((MouseEvent e) {
      new SetAttributeAction(_session, _task, 'completed',
          !_task.completed).doit();
    });

    _todo.query('.remove').onClick.listen((MouseEvent e) {
      var action = new RemoveAction(_session, _tasks, _task).doit();
    });

    return _todo;
  }

  remove() {
    _todo.remove();
  }

  complete(bool completed) {
    _completed.checked = completed;
    if (completed) {
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
