

class TaskModel{

  String name = '';
  String id = '';
  String description = '';
  String category = '';
  String status = '';
  DateTime dueDate = DateTime.now();

  TaskModel.empty();


  TaskModel.fromJson(Map<String,dynamic> json){
    name =  json["name"] ?? "";
    id =  json["id"] ?? "";
    description =  json["description"] ?? "";
    status =  json["status"] ?? "";
    category =  json["category"] ?? "";
    dueDate =  json["dueDate"]!=null?DateTime.fromMillisecondsSinceEpoch(json["dueDate"]):DateTime.now();
  }


  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "description": description,
      "category": category,
      "dueDate": dueDate.millisecondsSinceEpoch,
      "status": status,
    };
  }

  @override
  String toString() {
    return 'TaskModel{name: $name, description: $description, dueDate: $dueDate, category: $category}';
  }
}