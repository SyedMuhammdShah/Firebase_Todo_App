import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late String task;
  late String EditText;

  final fieldText = TextEditingController();
  final editText = TextEditingController();
  CollectionReference TaskReference =
      FirebaseFirestore.instance.collection('Todo');
  getStudentName(task) {
    this.task = task;
  }

  getEditStudentName(task) {
    this.EditText = task;
    print(EditText);
  }

  void _showcontent(task, docsId) {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Edit Task'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                // new Text('This is a Dialog Box. Click OK to Close.'),
                TextFormField(
                  controller: editText,
                  //initialValue: task,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: task,
                    fillColor: Colors.white,
                  ),
                  onChanged: (String task) {
                    getEditStudentName(task);
                  },
                ),
              ],
            ),
          ),
          actions: [
            new ElevatedButton(
              child: new Text('Ok'),
              onPressed: () async {
                editText.clear();
                print(docsId);
                print(EditText);
                await TaskReference.doc(docsId).update({"task": EditText});
                print(EditText);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> AddTask() {
    print("create");
    fieldText.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Task Add"),
      backgroundColor: Colors.deepOrange,
    ));
    CollectionReference students =
        FirebaseFirestore.instance.collection('Todo');
    return students
        .add({
          //Data added in the form of a dictionary into the document.
          'task': task,
        })
        .then((value) => print("Student data Added"))
        .catchError((error) => print("Student couldn't be added."));
  }

  void _deleteUser(String key) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          children: [
            Text("ToDo Application"),
            TextFormField(
              controller: fieldText,
              decoration: InputDecoration(
                labelText: "Name",
                fillColor: Colors.white,
              ),
              onChanged: (String task) {
                getStudentName(task);
              },
            ),
            ElevatedButton(
                onPressed: () {
                  AddTask();
                },
                child: Text("Add"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.transparent))))),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    "All Task",
                    style: TextStyle(fontSize: 20),
                  ),

                  // TaskList(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Todo')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var task = snapshot.data!.docs[index]['task'];
                                var docsId = snapshot.data!.docs[index].id;

                                return Card(
                                  child: ListTile(
                                    title: Text(task),
                                    trailing: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 54, 244, 171),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: IconButton(
                                        color: Colors.white,
                                        iconSize: 18,
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showcontent(task, docsId);
                                          // print(docsId);
                                          // FirebaseFirestore.instance
                                          //     .collection("Todo")
                                          //     .doc(docsId)
                                          //     .delete();
                                          // print("after button click");
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// DELETE BUTTON

//  IconButton(
//                                         color: Colors.white,
//                                         iconSize: 18,
//                                         icon: Icon(Icons.delete),
//                                         onPressed: () {
//                                           print(docsId);
//                                           FirebaseFirestore.instance
//                                               .collection("Todo")
//                                               .doc(docsId)
//                                               .delete();
//                                           print("after button click");
//                                         },
//                                       ),