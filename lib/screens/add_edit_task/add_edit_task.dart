




import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/service/network_service.dart';
import 'package:todo_app/utils/custom_dialogue.dart';
import 'package:todo_app/utils/snack_bar_service.dart';

class AddEditTask extends StatefulWidget {

  AddEditTask({super.key,this.task, this.isEdit=false,this.offLineMode=false});
  final TaskModel? task;
  final bool isEdit;
  final bool offLineMode;

  @override
  State<AddEditTask> createState() => _AddEditTaskState();
}

class _AddEditTaskState extends State<AddEditTask> {
  final nameCtrl = TextEditingController();

  final descriptionCtrl = TextEditingController();

  final confirmPasswordCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  String? category;

  String? status;

  bool internetConnection = true;

  final NetworkService networkService = NetworkService();

  final CustomDialogue customDialogue = CustomDialogue();

  checkEdit(){
    if(widget.isEdit){
      setState(() {
        descriptionCtrl.text = widget.task!.description;
        nameCtrl.text = widget.task!.name;
        category = widget.task!.category;
        selectedDate = widget.task!.dueDate;
        status = widget.task!.status;
      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkEdit();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate??DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()){
      if(category==null){
        SnackBarService.showError(message: "Please select a category");
        return;
      }
      if(selectedDate==null){
        SnackBarService.showError(message: "Please select due date for the task");
        return;
      }
      if(status==null){
        SnackBarService.showError(message: "Please select the status for the task");
        return;
      }
      customDialogue.showDialogue(context);
      TaskModel task = TaskModel.empty();
      task.name= nameCtrl.text;
      task.description= descriptionCtrl.text;
      task.category= category!;
      task.dueDate= selectedDate!;
      task.status = status!;
      internetConnection = await networkService.checkInternetConnectivity();
      if(widget.isEdit){
        task.id=widget.task!.id;
        if(!widget.offLineMode){
          if(internetConnection){
            await networkService.editTask(task, context);
          } else{
            Navigator.pop(context);
            Navigator.pop(context);
            SnackBarService.showError(message: "Cannot Edit task. Please check internet connection");
          }
        } else{
          await networkService.editTaskInOfflineMode(task, context);
        }
      } else{
        if(internetConnection){
          await networkService.addTask(task, context);
        } else{
          task.id=DateTime.now().millisecondsSinceEpoch.toString();
          await networkService.addTaskInOfflineMode(task, context);
        }
      }
    }
  }

  setCategory(String selectedCategory){
    if(category!=selectedCategory){
      setState(() {
        category=selectedCategory;
      });
    } else{
      setState(() {
        category=null;
      });
    }
  }

  setStatus(String selectedStatus){
    print("this is for print");
    if(status!=selectedStatus){
      setState(() {
        status=selectedStatus;
      });
    } else{
      setState(() {
        status=null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a Task",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(labelText: "Name"),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "name is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionCtrl,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "description is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16,),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Category",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: SizedBox(
                          width: double.infinity,
                          child:Wrap(
                            spacing: 10,runSpacing: 10,
                            direction: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  setCategory("Home");
                                },
                                child:Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(color:category=="Home"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5),width: 2),
                                  ),
                                  child: Text("Home",style:  TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w900,
                                      color: category=="Home"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5)
                                  ),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setCategory("Work");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(color: category=="Work"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5),width: 2),
                                  ),
                                  child: Text("Work",style:  TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w900,
                                      color:category=="Work"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5)
                                  ),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setCategory("Shopping");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(color:category=="Shopping"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5),width: 2),
                                  ),
                                  child: Text("Shopping",style:  TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w900,
                                      color: category=="Shopping"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5)
                                  ),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16,),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Status",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: SizedBox(
                          width: double.infinity,
                          child:Wrap(
                            spacing: 10,runSpacing: 10,
                            direction: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  setStatus("Not Started");
                                },
                                child:Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(color:status=="Not Started"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5),width: 2),
                                  ),
                                  child: Text("Not Started",style:  TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w900,
                                      color: status=="Not Started"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5)
                                  ),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setStatus("In Progress");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(color: status=="In Progress"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5),width: 2),
                                  ),
                                  child: Text("In Progress",style:  TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w900,
                                      color:status=="In Progress"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5)
                                  ),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setStatus("Completed");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(color:status=="Completed"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5),width: 2),
                                  ),
                                  child: Text("Completed",style:  TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w900,
                                      color: status=="Completed"?Colors.black:Color(0xff1b1b1b).withOpacity(0.5)
                                  ),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16,),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Due Date",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Text(
                                selectedDate == null
                                    ? "YYYY/MM/DD"
                                    : "${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text("Pick Date"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: !widget.isEdit,
                        child: ElevatedButton( // submit action button
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: Text(
                            "Add Task",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.isEdit,
                        child: ElevatedButton( // submit action button
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: Text(
                            "Edit Task",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: widget.isEdit,
                        child: ElevatedButton( // submit action button
                          onPressed: (){
                            customDialogue.showDeleteConfirmationDialog(context, ()async{
                              Navigator.pop(context);
                              customDialogue.showDialogue(context);
                              if(!widget.offLineMode){
                                internetConnection = await networkService.checkInternetConnectivity();
                                if(internetConnection){
                                  networkService.deleteTask(widget.task!.id, context);
                                } else{
                                  SnackBarService.showError(message: "Cannot delete task. Please check internet connection");
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              } else{
                                networkService.deleteTaskInOfflineMode(widget.task!.id, context);
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: Colors.red
                          ),
                          child: Text(
                            "Delete Task",
                            style: const TextStyle(fontSize: 16,color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
