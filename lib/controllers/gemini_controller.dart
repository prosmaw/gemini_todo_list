import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:todo_list/controllers/auth_controller.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/model/board.dart';
import 'package:todo_list/model/message.dart';
import 'package:todo_list/model/task.dart';

class GeminiControler extends GetxController {
  final GenerativeModel _model = GenerativeModel(
    model: "gemini-1.5-pro",
    apiKey: dotenv.get("API_KEY"),
    safetySettings: [
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
    ],
  );
  var message = ''.obs;
  TaskController taskController = Get.find();
  AppAuthController appAuthController = Get.find();
  var requesting = false.obs;
  var messages = <Message>[].obs;
  List<String> suggestions = [
    "Brief summary",
    "General improvement",
    "Task prioritization",
    "Insight",
    "Overall progress"
  ];

  Future<void> addTask(String userInput) async {
    message.value = '';
    requesting.value = true;
    update();
    final content = [
      Content.text(
          "Generate a task  from user input. Use the JSON format\ngiven below as copy"),
      Content.text(
          "task: add task buy bread for sunday june 9 at 9 AM on board Myself"),
      Content.text(
          "task copy: {\n\"status\": 200,\n\"dueDate\": \"2024-06-09 09:00:00\",\n\"name\": \"buy bread\",\n\"description\": \"no description\",\n\"boardName\": \"Myself\"\n}"),
      Content.text(
          "task: create task send email to boss 8 AM june 11 for board work"),
      Content.text(
          "task copy: {\n\"status\": 200,\n\"dueDate\": \"2024-06-11 08:00:00\",\n\"name\": \"send email\",\n\"description\": \"no description\",\n\"boardName\": \"Work\"\n}"),
      Content.text("task: create task clean toilet for board home"),
      Content.text(
          "task copy: {\n\"status\": 400,\n\"message\": \"Not enough information to proceed the request\"\n}"),
      Content.text(
          "task: $userInput. Note that today's date is ${DateTime.now()}"),
      Content.text("task copy: "),
    ];
    try {
      final response = await _model.generateContent(content,
          generationConfig: GenerationConfig(
              temperature: 0.5, responseMimeType: 'application/json'));
      final taskObject = response.text;
      final taskjson = jsonDecode(taskObject.toString());
      if (taskjson["status"] == 200) {
        Board? board =
            taskController.getBoard(taskjson["boardName"].toString());
        if (board == null) {
          message.value = "Board ${taskjson["boardName"]} does not exist";
        } else {
          Task task = Task(
              boardid: board.boardDocId.toString(),
              name: taskjson["name"],
              dueDate: DateTime.parse(taskjson["dueDate"]),
              creator: appAuthController.currentUser!.email,
              boardName: taskjson["boardName"],
              description: taskjson["description"],
              active: true,
              assignees: board.members,
              dateCreated: DateTime.now());
          await taskController.addtask(task);
          taskController.updateTasks();
          message.value = "Task added successfully";
        }
      } else if (taskjson["status"] == 400) {
        message.value =
            "Not enough information to proceed this request. Please be more precise";
      } else {
        message.value = "Something went wrong. Try again later";
      }
      requesting.value = false;
      if (kDebugMode) {
        debugPrint(message.value);
      }
    } catch (e) {
      requesting.value = false;
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      message.value = "Something went wrong. Try again";
    }
  }

  Future<void> insight(String input) async {
    final content = [
      Content.text(
          '''You are an assistant to users of a Todo list application, and your role is
          to help them improve by giving insight, recommendations, summaries, and other things
          the user ask that is related to their tasks. Only give response to what the 
          user ask. Return response if possible with markdowns to enhance user experience.
          '''),
      Content.text("This is the user input:"),
      Content.text("These are the tasks and their state: $input"),
    ];
    for (int i = 0; i < taskController.tasksDone.length; i++) {
      final taskContent =
          Content.text("${taskController.tasksDone[i].toJson()}");
      content.add(taskContent);
    }
    for (int i = 0; i < taskController.activeTasks.length; i++) {
      final taskContent =
          Content.text("${taskController.activeTasks[i].toJson()}");
      content.add(taskContent);
    }
    try {
      messages.add(Message(text: "", type: 0));
      final response = _model.generateContentStream(content,
          generationConfig: GenerationConfig(
              temperature: 0.5,
              maxOutputTokens: 300,
              responseMimeType: 'text/plain'));

      await for (final chunk in response) {
        // debugPrint(chunk.text.toString());
        messages.last.text += chunk.text.toString();
        update();
      }
      for (int i = 0; i <= 2; i++) {
        int id = Random().nextInt(suggestions.length);
        messages.add(Message(text: suggestions[id], type: 2));
      }
      update();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  void startingMessages() {
    messages.value = [];
    messages.add(Message(text: "Welcome! how can I help you today?", type: 0));
    for (int i = 0; i <= 2; i++) {
      int id = Random().nextInt(suggestions.length);
      messages.add(Message(text: suggestions[id], type: 2));
    }
  }
}
