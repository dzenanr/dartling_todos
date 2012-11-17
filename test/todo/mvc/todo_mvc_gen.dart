// test/todo/mvc/todo_mvc_gen.dart

import "dart:json";
import "dart:math";
import "dart:uri";

import "package:dartling/dartling.dart";

import "package:todo_mvc/todo_mvc.dart";

genCode() {
  var repo = new Repo();

  // change "Dartling" to "YourDomainName"
  var todoDomain = new Domain("Todo");

  // change dartling to yourDomainName
  // change Skeleton to YourModelName
  // change "Skeleton" to "YourModelName"
  Model todoMvcModel =
      fromMagicBoxes(todoMvcModelJson, todoDomain, "Mvc");

  repo.domains.add(todoDomain);

  repo.gen("todo_mvc");
}

initTodoData(TodoRepo todoRepo) {
   var todoModels =
       todoRepo.getDomainModels(TodoRepo.todoDomainCode);

   var todoMvcEntries =
       todoModels.getModelEntries(TodoRepo.todoMvcModelCode);
   initTodoMvc(todoMvcEntries);
   todoMvcEntries.display();
   todoMvcEntries.displayJson();
}

void main() {
  genCode();

  var todoRepo = new TodoRepo();
  initTodoData(todoRepo);
}