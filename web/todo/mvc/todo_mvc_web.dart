// web/todo/mvc/todo_mvc_web.dart

import "dart:html";
import "dart:isolate";

import "package:dartling/dartling.dart";
import "package:dartling/dartling_app.dart";

import "package:todo_mvc/todo_mvc.dart";

initTodoData(TodoRepo todoRepo) {
   var todoModels =
       todoRepo.getDomainModels(TodoRepo.todoDomainCode);

   var todoMvcEntries =
       todoModels.getModelEntries(TodoRepo.todoMvcModelCode);
   initTodoMvc(todoMvcEntries);
   todoMvcEntries.display();
   todoMvcEntries.displayJson();
}

showTodoData(TodoRepo todoRepo) {
   var mainView = new View(document, "main");
   mainView.repo = todoRepo;
   new RepoMainSection(mainView);
}

void main() {
  var todoRepo = new TodoRepo();
  initTodoData(todoRepo);
  showTodoData(todoRepo);
}