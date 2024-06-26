import 'package:api_5_firebase/model/todo_model.dart';
import 'package:api_5_firebase/screen/login_screen/login_page.dart';
import 'package:api_5_firebase/screen/user_profile/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  late CollectionReference allData;

  String? userId;
  String? singleNoteId;
  bool isCompleted = false;

  DateFormat dateFormat = DateFormat("h:mm a");

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(LoginPage.USER_ID);
    print('todo page: $userId');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    allData = fireStore.collection('users').doc(userId).collection('notes');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
              },
              icon: const Icon(Icons.person))
        ],
      ),
      backgroundColor: Colors.blueGrey.shade200,
      body: userId != null ? FutureBuilder(
        future: fireStore.collection('users').doc(userId).collection('notes').orderBy('createdAt', descending: true).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.hasError}'));
                }

                if (snapshot.hasData) {
                  
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      TodoModel todoModel = TodoModel.fromJSONDoc(snapshot.data!.docs[index].data());
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              titleController.text = todoModel.title!;
                              descController.text = todoModel.desc!;
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return customBottomSheet(
                                      isUpdate: true,
                                      updateIndex: snapshot.data!.docs[index].id.toString(),
                                  );
                                },
                              );
                            },
                            tileColor: todoModel.isCompleted! ? Colors.green.shade300 : null,
                            leading: Checkbox(
                              value: todoModel.isCompleted,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCompleted = value!;
                                  allData.doc(snapshot.data!.docs[index].id).update(
                                      {"isCompleted": value});
                                });
                              },
                            ),
                            
                            title: Text(todoModel.title.toString()),
                            subtitle: Text(todoModel.desc.toString()),
                            trailing: Column(
                              children: [
                                Text(
                                  todoModel.createdAt.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () {
                                    allData.doc(snapshot.data!.docs[index].id).delete().then((value) => print('Deleted ..'));
                                    setState(() {});
                                  },
                                  
                                  child: const Icon(Icons.delete),
                                  
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            )
          : const Center(child: Text('No Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descController.clear();

          showModalBottomSheet(
            context: context,
            builder: (context) {
              return customBottomSheet();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget customBottomSheet({bool isUpdate = false, String updateIndex = ""}) {
    return Container(
      height: 600,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      if (!isUpdate) {
                        TodoModel todoAddNotes = TodoModel(
                            userId: userId,
                            title: titleController.text,
                            desc: descController.text,
                            createdAt: dateFormat.format(DateTime.now()),
                            completedAt: dateFormat.format(DateTime.now()));
                        
                        // 
                        await allData.add(todoAddNotes.toMapDoc());
                      } else {
                        TodoModel todoUpdateNotes = TodoModel(
                            noteId: singleNoteId.toString(),
                            userId: userId,
                            title: titleController.text,
                            desc: descController.text,
                            createdAt: dateFormat.format(DateTime.now()),
                            completedAt: dateFormat.format(DateTime.now()));
                        // await allData.add(todoNotes.toMapDoc());
                        fireStore.collection('users').doc(userId).collection('notes').doc(updateIndex).update(todoUpdateNotes.toMapDoc());
                      }
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text(isUpdate ? 'Update' : 'Save')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
