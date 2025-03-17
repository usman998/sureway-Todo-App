



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_edit_task/add_edit_task.dart';
import 'package:todo_app/screens/auth_screen/auth_screen.dart';
import 'package:todo_app/user_preference.dart';

class CustomScaffold extends StatelessWidget {


  final List<Widget> children;
  final Function() filterTap;
  final Function() checkConnection;
  final AppBar? appbar;

  const CustomScaffold({super.key,required this.children,required this.filterTap,this.appbar,required this.checkConnection});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appbar,
      bottomNavigationBar: Container(
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            offset:const  Offset(0, -10),
            blurRadius: 15,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: _height * 0.02, top: _height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                UserPreferences.clearPrefs();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()), // Replace with your screen widget
                );
              },
              child: Container(
                color: Colors.black,
                height: 63,
                width: double.infinity,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.logout,color: Colors.white,),
                    SizedBox(height: _height*0.005,),
                    Text(
                      "Logout",maxLines: 1,overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),),
                    SizedBox(height: _height*0.01,)
                  ],),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: filterTap,
              child: Container(
                height: 63,
                color: Colors.black,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sort,color: Colors.white,),
                    SizedBox(height: _height*0.005,),
                    const Text("Filters",style: TextStyle(
                        color: Colors.white),),
                    SizedBox(height: _height*0.01,),
                  ],),
              ),
            ),
          )
        ],
      ),

    ),
      body: Stack(
        children: [
          Positioned(
            left: 0,right: 0,top: 0,bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding:const  EdgeInsets.only(right: 20, bottom: 30), // Ensure same padding
              child: FloatingActionButton(
                heroTag: "rightFAB",
                onPressed: () async{
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEditTask()), // Replace with your screen widget
                  );
                  checkConnection();
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




