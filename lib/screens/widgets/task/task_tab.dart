import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/gemini_controller.dart';
import 'package:todo_list/controllers/task_controller.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/screens/pages/insight_page.dart';
import 'package:todo_list/screens/widgets/task/task_done_widget.dart';
import 'package:todo_list/screens/widgets/task/task_state_button.dart';
import 'package:todo_list/screens/widgets/task/task_widget.dart';
import 'package:todo_list/utils/base_colors.dart';
import 'package:todo_list/utils/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({
    super.key,
  });

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> with TickerProviderStateMixin {
  bool activeSelected = true;
  bool doneSelected = false;
  final TaskController taskController = Get.find();
  final GeminiControler geminiControler = Get.find();
  late final TabController tabController = TabController(
      length: 7, vsync: this, initialIndex: (DateTime.now().weekday - 1));
  Task fakeTask = Task(
      name: BoneMock.name,
      dueDate: DateTime.now(),
      boardName: BoneMock.name,
      description: " ",
      active: true,
      dateCreated: DateTime.now(),
      boardid: '',
      creator: '',
      assignees: []);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<TaskController>(builder: (_) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Insight container
              GestureDetector(
                onTap: () {
                  geminiControler.startingMessages();
                  Get.to(() => const InsightPage());
                },
                child: Container(
                  height: 40,
                  width: 100,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: BaseColors.secondaryColor)),
                  child: const Center(
                    child: Text(
                      "Insights",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              //Active and done buttons
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeSelected = true;
                        doneSelected = false;
                      });
                    },
                    child: TaskStateButton(
                      name: 'Active',
                      isSelected: activeSelected,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeSelected = false;
                        doneSelected = true;
                      });
                    },
                    child: TaskStateButton(
                      name: 'Done',
                      isSelected: doneSelected,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          activeSelected
              ? TabBar(
                  controller: tabController,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelStyle: const TextStyle(color: BaseColors.grey),
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: List.generate(
                      Constants.days.length,
                      (daysIndex) => Tab(
                            text: Constants.days[daysIndex],
                          )))
              : const SizedBox(),
          activeSelected
              ? Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: taskController.isloaded.value
                          ? List.generate(7, (index) {
                              return taskController.dayTasks[index].isNotEmpty
                                  ? ListView.builder(
                                      //case task list is not empty
                                      itemCount:
                                          taskController.dayTasks[index].length,
                                      itemBuilder: (BuildContext context,
                                          int taskIndex) {
                                        return TaskWidget(
                                            width: width,
                                            height: height,
                                            task: taskController.dayTasks[index]
                                                [taskIndex],
                                            done: false);
                                      },
                                    )
                                  : Column(
                                      //case task list is empty
                                      children: [
                                        Container(
                                          height: (width) / 3,
                                          width: (width) / 3,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: AssetImage(
                                                      "assets/images/clipboard.png"))),
                                        ),
                                        const Text(
                                          "No Task avalaible",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )
                                      ],
                                    );
                            })
                          : List.generate(
                              // case loading
                              7,
                              (index) => Skeletonizer(
                                    child: ListView(
                                      children: [
                                        TaskWidget(
                                          width: width,
                                          height: height,
                                          task: fakeTask,
                                          done: false,
                                        ),
                                        TaskWidget(
                                            width: width,
                                            height: height,
                                            task: fakeTask,
                                            done: false),
                                        TaskWidget(
                                            width: width,
                                            height: height,
                                            task: fakeTask,
                                            done: false),
                                      ],
                                    ),
                                  ))),
                )
              : Expanded(child: TaskDoneWidget())
        ],
      );
    });
  }
}
