

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/user_preference.dart';
import 'package:todo_app/utils/snack_bar_service.dart';
import 'package:http/http.dart' as http;

class NetworkService {

  NetworkService._internalConstructor();

  static final NetworkService _instance = NetworkService._internalConstructor();

  factory NetworkService(){
    return _instance;
  }


  Future<List<TaskModel>> getTaskList() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final docSnapshot = await FirebaseFirestore.instance.collection('userTask').doc(userId).get();

    if (!docSnapshot.exists || docSnapshot.data() == null) return [];

    final data = docSnapshot.data();
    final todoList = (data?['todoList'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    return todoList.map((task) => TaskModel.fromJson(task)).toList();
  }


  // Future<List<TaskModel>> getTaskList () async{
  //   List<TaskModel> taskList = [];
  //   try{
  //     var taskData = FirebaseFirestore.instance.collection('userTask').doc(FirebaseAuth.instance.currentUser?.uid).get();
  //     TaskModel data;
  //     await taskData.then((documentSnapshot) => {
  //       if(documentSnapshot.exists && documentSnapshot.data()?["todoList"]!=null && documentSnapshot.data()?["todoList"] is List){
  //         for(var item in documentSnapshot.data()?["todoList"]){
  //           // log("this is the the document $item "),
  //           taskList.add(TaskModel.fromJson(json:item)),
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     return taskList;
  //   }
  //   return taskList;
  // }



  Future<void> addTask(TaskModel task, BuildContext context) async{
    await FirebaseFirestore.instance
        .collection("userTask")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "todoList":
      FieldValue.arrayUnion([{
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "name" : task.name,
        "description" : task.description,
        "dueDate" : task.dueDate.millisecondsSinceEpoch,
        "category" : task.category,
        "status" : task.status
      }])
    }).then((e)async{
      SnackBarService.showSuccess("Task added successfully");
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e){
      SnackBarService.showError();
      Navigator.pop(context);
    });
  }






  Future<void> editTask(TaskModel updatedTask,BuildContext context) async {
    List<TaskModel> taskList = await getTaskList();
    List tempTaskList = [];
    for(var item in taskList){
      if(item.id != updatedTask.id ){
        tempTaskList.add(item.toJson());
      } else{
        tempTaskList.add(updatedTask.toJson());
      }
    }
    await FirebaseFirestore.instance
        .collection("userTask")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "todoList":tempTaskList
    }).then((e)async{
      SnackBarService.showSuccess("Task Edited successfully");
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e){
      SnackBarService.showError();
      Navigator.pop(context);
    });
  }


  Future<void> deleteTask(String id ,BuildContext context) async {
    List<TaskModel> taskList = await getTaskList();
    List tempTaskList = [];
    for(var item in taskList){
      if(item.id != id ){
        tempTaskList.add(item.toJson());
      }
    }
    await FirebaseFirestore.instance
        .collection("userTask")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "todoList":tempTaskList
    }).then((e)async{
      SnackBarService.showSuccess("Task Deleted successfully");
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e){
      SnackBarService.showError();
      Navigator.pop(context);
    });
  }


  Future<bool> checkInternetConnectivity() async {
    try {
      final response = await http.get(Uri.parse("https://www.google.com"))
          .timeout(Duration(seconds: 5));  // Timeout after 5 seconds

      if (response.statusCode == 200) {
        return true; // Internet is available
      }
    } catch (e) {
      return false; // No internet or request failed
    }
    return false;
  }


  editTaskInOfflineMode(TaskModel updatedTask,BuildContext context)async{
    List<TaskModel> taskList = await UserPreferences.getTasks();
    List<TaskModel> tempTaskList = [];
    for(var item in taskList){
      if(item.id != updatedTask.id ){
        tempTaskList.add(item);
      } else{
        tempTaskList.add(updatedTask);
      }
    }
    await UserPreferences.saveTasks(tempTaskList);
    // SnackBarService.showSuccess("Task Edited in offline mode successfully");
    // Navigator.pop(context);
    // Navigator.pop(context);
  }


  deleteTaskInOfflineMode(String id,BuildContext context)async{
    List<TaskModel> taskList = await UserPreferences.getTasks();
    List<TaskModel> tempTaskList = [];
    for(var item in taskList){
      if(item.id != id ){
        tempTaskList.add(item);
      }
    }
    await UserPreferences.saveTasks(tempTaskList);
    SnackBarService.showSuccess("Task Deleted in offline mode successfully");
    Navigator.pop(context);
    Navigator.pop(context);
  }



  addTaskInOfflineMode(TaskModel task, BuildContext context) async{
    List<TaskModel> offlineTask = await UserPreferences.getTasks();
    offlineTask.add(task);
    await UserPreferences.saveTasks(offlineTask);
    SnackBarService.showSuccess("Task Added in offline mode successfully");
    Navigator.pop(context);
    Navigator.pop(context);
  }


}