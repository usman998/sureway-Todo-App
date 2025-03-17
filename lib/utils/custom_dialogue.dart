


import 'package:flutter/material.dart';

class CustomDialogue{

  CustomDialogue._internalConstructor();

  static final CustomDialogue _instance = CustomDialogue._internalConstructor();

  factory CustomDialogue(){
    return _instance;
  }



  showDialogue(BuildContext context) {
    return showDialog(
        context: context,
        barrierColor: Colors.white54,
        builder: (BuildContext context) {
          return SizedBox(height: double.infinity,width: double.infinity,
            child: Center(child: CircularProgressIndicator(),),
          );
        });
  }


  Future<void> showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this task? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onConfirm();  // Execute the delete function
                // Navigator.pop(context); // Close the dialog
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


}