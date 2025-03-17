import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/screens/task_screen/widget/custom_scaffold.dart';
import 'package:todo_app/screens/task_screen/widget/no_internet_banner.dart';
import 'package:todo_app/screens/task_screen/widget/task_card.dart';
import 'package:todo_app/service/network_service.dart';
import 'package:todo_app/user_preference.dart';
import 'package:todo_app/utils/custom_dialogue.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<TaskModel> taskList = [];
  List<TaskModel> offLineTaskList = [];
  final NetworkService networkService = NetworkService();
  final CustomDialogue customDialogue = CustomDialogue();
  final UserPreferences userPreferences = UserPreferences();

  getLiveChanges() async {
    DocumentReference reference = FirebaseFirestore.instance
        .collection("userTask")
        .doc(FirebaseAuth.instance.currentUser?.uid);
    reference.snapshots().listen((querySnapshot) {
      getTaskList();
    });
  }

  bool internetConnectivity = true;

  checkConnection() async {
    internetConnectivity = await networkService.checkInternetConnectivity();
    await getOfflineTask();
    setState(() {

    });
  }

  getTaskList() async {
    customDialogue.showDialogue(context);
    await checkConnection();
    selectedStatus = "All";
    selectedCategory = "All";
    if (internetConnectivity) {
      taskList = await networkService.getTaskList();
    }
    Navigator.pop(context);
    setState(() {});
  }

  saveTask() async {
    await UserPreferences.saveTasks(taskList);
  }

  getOfflineTask() async {
    offLineTaskList = await UserPreferences.getTasks();

  }

  String selectedCategory = "All";
  String selectedStatus = "All";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLiveChanges();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appbar: AppBar(
        title: Text(
          "Todo List",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      checkConnection: checkConnection,
      filterTap: () {
        showFilterBottomSheet(context, selectedCategory, selectedStatus,
            (category, status) {
          setState(() {
            selectedCategory = category;
            selectedStatus = status;
          });
        });
      },
      children: internetConnectivity == false
          ? [
              NoInternetBanner(
                onRetry: () {
                  getTaskList();
                },
              ),
              clearFilterHeader(),
              offLineTaskList.isEmpty
                  ? Container(
                      padding: EdgeInsets.only(top: 250),
                      alignment: Alignment.center,
                      child: Text(
                        "No Task added",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: offLineTaskList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (selectedCategory == "All" &&
                            selectedStatus == "All") {
                          return TaskCard(task: offLineTaskList[index],offlineMode:true,callBack: checkConnection,);
                        } else if (selectedCategory != "All" &&
                            selectedStatus != "All") {
                          return offLineTaskList[index].category == selectedCategory &&
                              offLineTaskList[index].status.toString() ==
                                      selectedStatus
                              ? TaskCard(task: offLineTaskList[index],offlineMode:true,callBack: checkConnection,)
                              : Container();
                        } else if (selectedCategory != "All" &&
                            selectedStatus == "All") {
                          return offLineTaskList[index].category == selectedCategory
                              ? TaskCard(task: offLineTaskList[index],offlineMode:true,callBack: checkConnection,)
                              : Container();
                        } else if (selectedCategory == "All" &&
                            selectedStatus != "All") {
                          return offLineTaskList[index].status.toString() ==
                                  selectedStatus
                              ? TaskCard(task: offLineTaskList[index],offlineMode:true,callBack: checkConnection,)
                              : Container();
                        }
                        return null;
                      },
                    ),
              SizedBox(
                height: 150,
              ),
            ]
          : [
              clearFilterHeader(),
              taskList.isEmpty
                  ? Container(
                      padding: EdgeInsets.only(top: 250),
                      alignment: Alignment.center,
                      child: Text(
                        "No Task added",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: taskList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (selectedCategory == "All" &&
                            selectedStatus == "All") {
                          return TaskCard(task: taskList[index],callBack: checkConnection,);
                        } else if (selectedCategory != "All" &&
                            selectedStatus != "All") {
                          return taskList[index].category == selectedCategory &&
                                  taskList[index].status.toString() ==
                                      selectedStatus
                              ? TaskCard(task: taskList[index],callBack: checkConnection,)
                              : Container();
                        } else if (selectedCategory != "All" &&
                            selectedStatus == "All") {
                          return taskList[index].category == selectedCategory
                              ? TaskCard(task: taskList[index],callBack: checkConnection,)
                              : Container();
                        } else if (selectedCategory == "All" &&
                            selectedStatus != "All") {
                          return taskList[index].status.toString() ==
                                  selectedStatus
                              ? TaskCard(task: taskList[index],callBack: checkConnection,)
                              : Container();
                        }
                        return null;
                      },
                    ),
              SizedBox(
                height: 150,
              ),
            ],
    );
  }

  Visibility clearFilterHeader() {
    return Visibility(
      visible: selectedCategory != "All" || selectedStatus != "All",
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
        child: Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedStatus = "All";
                selectedCategory = "All";
              });
            },
            child: Text(
              "Remove Filters",
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Colors.red,
                // Red underline
                decorationThickness: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showFilterBottomSheet(
    BuildContext context,
    String selectedCategory,
    String selectedStatus,
    Function(String, String) onFilterSelected,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String tempCategory = selectedCategory;
        String tempStatus = selectedStatus;

        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sort by Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Column(
                      children:
                          ["All", "Home", "Shopping", "Work"].map((category) {
                        return InkWell(
                          onTap: () {
                            setState(() => tempCategory = category);
                          },
                          child: Row(
                            children: [
                              Radio<String>(
                                value: category,
                                groupValue: tempCategory,
                                onChanged: (value) {
                                  setState(() => tempCategory = value!);
                                },
                              ),
                              Text(category),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    Text("Sort by Status",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Column(
                      children: [
                        "All",
                        "Not Started",
                        "In Progress",
                        "Completed"
                      ].map((status) {
                        return InkWell(
                          onTap: () {
                            setState(() => tempStatus = status);
                          },
                          child: Row(
                            children: [
                              Radio<String>(
                                value: status,
                                groupValue: tempStatus,
                                onChanged: (value) {
                                  setState(() => tempStatus = value!);
                                },
                              ),
                              Text(status),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        onFilterSelected(tempCategory, tempStatus);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(double.infinity, 50), // Full-width button
                      ),
                      child: const Text("Apply Filter"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}




