part of todo_mvc;

// lib/todo/mvc/init.dart

initTodoMvc(var entries) {
  _initTasks(entries);
}

_initTasks(var entries) {
  Task task1 = new Task(entries.tasks.concept);
  task1.title = 'Design a model with Magic Boxes.';
  entries.tasks.add(task1);

  Task task2 = new Task(entries.tasks.concept);
  task2.title = 'Generate JSON for thed model in Magic Boxes.';
  entries.tasks.add(task2);
}
