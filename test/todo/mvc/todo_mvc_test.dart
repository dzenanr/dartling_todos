// test/todo/mvc/todo_mvc_test.dart

import "package:unittest/unittest.dart";

import "package:dartling/dartling.dart";

import "package:todo_mvc/todo_mvc.dart";

testTodoMvc(Repo repo, String domainCode, String modelCode) {
  TodoModels models;
  DomainSession session;
  MvcEntries entries;
  Tasks tasks;
  int count = 0;
  Concept concept;
  group("Testing ${domainCode}.${modelCode}", () {
    setUp(() {
      models = repo.getDomainModels(domainCode);
      session = models.newSession();
      entries = models.getModelEntries(modelCode);
      expect(entries, isNotNull);
      tasks = entries.tasks;
      expect(tasks.count, equals(count));
      concept = tasks.concept;
      expect(concept, isNotNull);
      expect(concept.attributes.list, isNot(isEmpty));

      var design = new Task(concept);
      expect(design, isNotNull);
      design.title = 'design a model';
      tasks.add(design);
      expect(tasks.count, equals(++count));

      var json = new Task(concept);
      json.title = 'generate json from the model';
      tasks.add(json);
      expect(tasks.count, equals(++count));

      var generate = new Task(concept);
      generate.title = 'generate code from the json document';
      tasks.add(generate);
      expect(tasks.count, equals(++count));
    });
    tearDown(() {
      tasks.clear();
      expect(tasks.empty, isTrue);
      count = 0;
    });
    /*
    test('Empty Entries Test', () {
      entries.clear();
      expect(entries.empty, isTrue);
    });

    test('From Tasks to JSON', () {
      var json = tasks.toJson();
      expect(json, isNotNull);
      print(json);
    });
    test('From Task Model to JSON', () {
      var json = entries.toJson();
      expect(json, isNotNull);
      entries.displayJson();
    });
    test('From JSON to Task Model', () {
      tasks.clear();
      expect(tasks.empty, isTrue);
      entries.fromJsonToData();
      expect(tasks.empty, isFalse);
      tasks.display(title:'From JSON to Task Model');
    });

    test('Add Task Required Title Error', () {
      var task = new Task(concept);
      expect(concept, isNotNull);
      var added = tasks.add(task);
      expect(added, isFalse);
      expect(tasks.count, equals(count));
      expect(tasks.errors.count, equals(1));
      expect(tasks.errors.list[0].category, equals('required'));
      tasks.errors.display(title:'Add Task Required Title Error');
    });
    test('Add Task Pre Validation', () {
      var task = new Task(concept);
      task.title =
          'A new todo task with a long title that cannot be accepted if it is '
          'longer than 64 characters';
      var added = tasks.add(task);
      expect(added, isFalse);
      expect(tasks.count, equals(count));
      expect(tasks.errors, hasLength(1));
      expect(tasks.errors.list[0].category, equals('pre'));
      tasks.errors.display(title:'Add Task Pre Validation');
    });

    test('Find Task by New Oid', () {
      var oid = new Oid.ts(1345648254063);
      var task = tasks.find(oid);
      expect(task, isNull);
    });
    test('Find Task by Attribute', () {
      var title = 'generate json from the model';
      var task = tasks.findByAttribute('title', title);
      expect(task, isNotNull);
      expect(task.title, equals(title));
    });
    test('Random Task', () {
      var task1 = tasks.random();
      expect(task1, isNotNull);
      task1.display(prefix:'random 1');
      var task2 = tasks.random();
      expect(task2, isNotNull);
      task2.display(prefix:'random 2');
    });

    test('Select Tasks by Function', () {
      Tasks generateTasks = tasks.select((task) => task.generate);
      expect(generateTasks.empty, isFalse);
      expect(generateTasks.length, equals(2));

      generateTasks.display(title:'Select Tasks by Function');
    });
    test('Select Tasks by Function then Add', () {
      var generateTasks = tasks.select((task) => task.generate);
      expect(generateTasks.empty, isFalse);
      expect(generateTasks.source.empty, isFalse);

      var programmingTask = new Task(concept);
      programmingTask.title = 'dartling programming';
      var added = generateTasks.add(programmingTask);
      expect(added, isTrue);

      generateTasks.display(title:'Select Tasks by Function then Add');
      tasks.display(title:'All Tasks');
    });
    test('Select Tasks by Function then Remove', () {
      var generateTasks = tasks.select((task) => task.generate);
      expect(generateTasks.empty, isFalse);
      expect(generateTasks.source.empty, isFalse);

      var title = 'generate json from the model';
      var task = generateTasks.findByAttribute('title', title);
      expect(task, isNotNull);
      expect(task.title, equals(title));
      var generateCount = generateTasks.count;
      generateTasks.remove(task);
      expect(generateTasks.count, equals(--generateCount));
      expect(tasks.count, equals(--count));
    });
    test('Order Tasks by Title', () {
      Tasks orderedTasks =tasks.order();
      expect(orderedTasks.empty, isFalse);
      expect(orderedTasks.count, equals(tasks.count));
      expect(orderedTasks.source.empty, isFalse);
      expect(orderedTasks.source.count, equals(tasks.count));

      orderedTasks.display(title:'Order Tasks by Title');
    });

    test('Copy Tasks', () {
      Tasks copiedTasks = tasks.copy();
      expect(copiedTasks.empty, isFalse);
      expect(copiedTasks.count, equals(tasks.count));
      expect(copiedTasks, isNot(same(tasks)));
      expect(copiedTasks, equals(tasks));
      copiedTasks.forEach((ct) =>
          expect(ct, isNot(same(tasks.findByAttribute('title', ct.title)))));
      copiedTasks.display(title:'Copied Tasks');
    });
    test('Copy Equality', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.count, equals(++count));

      task.display(prefix:'before copy: ');
      var copiedDoc = task.copy();
      copiedDoc.display(prefix:'after copy: ');
      expect(task, equals(copiedDoc));
      expect(task.oid, equals(copiedDoc.oid));
      expect(task.code, equals(copiedDoc.code));
      expect(task.title, equals(copiedDoc.title));
      expect(task.completed, equals(copiedDoc.completed));
    });

    test('True for Every Task', () {
      expect(tasks.every((t) => t.code == null), isTrue);
      expect(tasks.every((t) => t.title != null), isTrue);
    });

    test('Update New Project Description with Failure', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.count, equals(++count));

      var copiedDoc = task.copy();
      copiedDoc.title = 'writing a paper on Dartling';
      // Entities.update can only be used if oid, generate or id set.
      expect(() => tasks.update(task, copiedDoc), throws);
    });

    test('New Task Undo and Redo', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.count, equals(++count));

      var action = new AddAction(session, tasks, task);
      action.doit();
      expect(tasks.count, equals(++count));

      action.undo();
      expect(tasks.count, equals(--count));

      action.redo();
      expect(tasks.count, equals(++count));
    });
    test('New Task Undo and Redo with Session', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.count, equals(++count));

      var action = new AddAction(session, tasks, task);
      action.doit();
      expect(tasks.count, equals(++count));

      session.past.undo();
      expect(tasks.count, equals(--count));

      session.past.redo();
      expect(tasks.count, equals(++count));
    });
    */
    test('Task Actions with Multiple Undos and Redos', () {
      var task1 = new Task(concept);
      task1.title = 'writing a tutorial on Dartling';

      var action1 = new AddAction(session, tasks, task1);
      action1.doit();
      expect(tasks.count, equals(++count));

      var task2 = new Task(concept);
      task2.title = 'preparing a course lecture on DOM';

      var action2 = new AddAction(session, tasks, task2);
      action2.doit();
      expect(tasks.count, equals(++count));

      //session.past.display();

      session.past.undo();
      expect(tasks.count, equals(--count));
      session.past.display();

      session.past.undo();
      expect(tasks.count, equals(--count));
      session.past.display();

      session.past.redo();
      expect(tasks.count, equals(++count));
      session.past.display();

      session.past.redo();
      expect(tasks.count, equals(++count));
      session.past.display();
    });
    /*
    test('Undo and Redo Update Task Title', () {
      var title = 'generate json from the model';
      var task = tasks.findByAttribute('title', title);
      expect(task, isNotNull);
      expect(task.title, equals(title));

      var action =
          new SetAttributeAction(session, task, 'title',
              'generate from model to json');
      action.doit();

      session.past.undo();
      expect(task.title, equals(action.before));

      session.past.redo();
      expect(task.title, equals(action.after));
    });
    test('Undo and Redo Transaction', () {
      var task1 = new Task(concept);
      task1.title = 'data modeling';
      var action1 = new AddAction(session, tasks, task1);

      var task2 = new Task(concept);
      task2.title = 'database design';
      var action2 = new AddAction(session, tasks, task2);

      var transaction = new Transaction('two adds on tasks', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doit();
      count = count + 2;
      expect(tasks.count, equals(count));
      tasks.display(title:'Transaction Done');

      session.past.undo();
      count = count - 2;
      expect(tasks.count, equals(count));
      tasks.display(title:'Transaction Undone');

      session.past.redo();
      count = count + 2;
      expect(tasks.count, equals(count));
      tasks.display(title:'Transaction Redone');
    });

    test('Reactions to Project Actions', () {
      var reaction = new Reaction();
      expect(reaction, isNotNull);

      models.startActionReaction(reaction);
      var task = new Task(concept);
      task.title = 'validate dartling documentation';

      var session = models.newSession();
      var addAction = new AddAction(session, tasks, task);
      addAction.doit();
      expect(tasks.count, equals(++count));
      expect(reaction.reactedOnAdd, isTrue);

      var title = 'documenting dartling';
      var setAttributeAction =
          new SetAttributeAction(session, task, 'title', title);
      setAttributeAction.doit();
      expect(reaction.reactedOnUpdate, isTrue);
      models.cancelActionReaction(reaction);
    });
*/
  });
}

class Reaction implements ActionReactionApi {

  bool reactedOnAdd = false;
  bool reactedOnUpdate = false;

  react(BasicAction action) {
    if (action is EntitiesAction) {
      reactedOnAdd = true;
    } else if (action is EntityAction) {
      reactedOnUpdate = true;
    }
  }

}

testTodoData(TodoRepo todoRepo) {
  testTodoMvc(todoRepo, TodoRepo.todoDomainCode,
      TodoRepo.todoMvcModelCode);
}

void main() {
  var todoRepo = new TodoRepo();
  testTodoData(todoRepo);
}