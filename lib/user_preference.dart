


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/task_model.dart';


class UserPreferences {
  UserPreferences._internalConstructor();

  static final UserPreferences _instance = UserPreferences._internalConstructor();

  factory UserPreferences(){
    return _instance;
  }



  static SharedPreferences? _prefs;

  static const String _taskListKey = "task_list";

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }




  static Future<void> setBool({required String key, required bool value}) async {
    if (_prefs != null) {
      await _prefs!.setBool(key, value);
    } else {
      throw Exception('UserPreferences is not initialized');
    }
  }

  static bool? getBool(String key) {
    if (_prefs != null) {
      return _prefs!.getBool(key);
    } else {
      throw Exception('UserPreferences is not initialized');
    }
  }


  static Future<void> setString({required String key, required String value}) async {
    if (_prefs != null) {
      await _prefs!.setString(key, value);
    } else {
      throw Exception('UserPreferences is not initialized');
    }
  }

  static String? getString(String key) {
    if (_prefs != null) {
      return _prefs!.getString(key);
    } else {
      throw Exception('UserPreferences is not initialized');
    }
  }




  static Future<void> saveTasks(List<TaskModel> tasks) async {
    List<String> jsonTasks = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await _prefs?.setStringList(_taskListKey, jsonTasks);
  }


  static Future<List<TaskModel>> getTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonTasks = prefs.getStringList(_taskListKey);
    if (jsonTasks == null) return [];
    return jsonTasks.map((json) => TaskModel.fromJson(jsonDecode(json))).toList();
  }


  static void clearPrefs()async {
    if (_prefs != null) {
      await _prefs!.clear();
    } else {
      throw Exception('UserPreferences is not initialized');
    }
  }


}