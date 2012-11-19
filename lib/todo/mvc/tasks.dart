part of todo_mvc;

// lib/todo/mvc/tasks.dart

class Task extends TaskGen {

  Task(Concept concept) : super(concept);

  fromJson(Map json) {
    title = json['title'];
    String completedString = json['completed'];
    if (completedString.trim() == 'true') {
      completed = true;
    }
  }

  bool get left => !completed;

  bool get generate =>
      title.contains('generate') ? true : false;

  /**
   * Compares two tasks based on the title.
   * If the result is less than 0 then the first entity is less than the second,
   * if it is equal to 0 they are equal and
   * if the result is greater than 0 then the first is greater than the second.
   */
  int compareTo(Task other) {
    return title.compareTo(other.title);
  }

}

class Tasks extends TasksGen {

  Tasks(Concept concept) : super(concept);

  Tasks get completed => select((task) => task.completed);
  Tasks get left => select((task) => task.left);

  fromJson(String json) {
    try {
      List jsonList = JSON.parse(json);
      for (Map todo in jsonList) {
        var task = new Task(concept);
        task.fromJson(todo);
        add(task);
      }
    } catch (e) {
      EntityError error = new EntityError('json');
      error.message = 'Tasks not created from the JSON text: ${e}';
      errors.add(error);
    }
  }

  bool preAdd(Task task) {
    bool validation = super.preAdd(task);
    if (validation) {
      validation = task.title.length <= 64;
      if (!validation) {
        var error = new EntityError('pre');
        error.message =
            '${concept.codePlural}.preAdd rejects the "${task.title}" '
            'title that is longer than 64.';
        errors.add(error);
      }
    }
    return validation;
  }

  String errorMessage() {
    if (errors.count > 0) {
      List<EntityError> errorList = errors.list;
      var msgs = '';
      for (var error in errorList) {
        msgs = '${msgs} \n ${error.category}: ${error.message}';
      }
      return msgs;
    } else {
      return '';
    }
  }

}
