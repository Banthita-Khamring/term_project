// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:term_project/widgets/tasks.dart';
// import 'package:http/http.dart' as http;

// class ShowTasks extends StatefulWidget {
//   const ShowTasks({Key? key}) : super(key: key);

//   @override
//   State<ShowTasks> createState() => _ShowTasksState();
// }

// class _ShowTasksState extends State<ShowTasks> {
//   //List? _tasks; //_todoItems

//   final String _apiUrl = 'http://localhost:3000';
//   final _taskNameController = TextEditingController();
//   final _taskDescriptionController = TextEditingController();

//   Future<List<Tasks>> fetchTasks() async {
//     final response = await http.get(Uri.parse('$_apiUrl/showtasks'));
//     if (response.statusCode == 200) {
//       final List<dynamic> itemtasks = json.decode(response.body);
//       final List<Tasks> items = itemtasks.map((item) {
//         return Tasks.fromJson(item);
//       }).toList();
//       return items;
//     } else {
//       throw Exception('Failed to load tasks');
//     }
//   }

// // เอาออกได้
//   // Future<Tasks> addTask(String taskName, String taskDescription) async {
//   //   final response = await http.post(
//   //     Uri.parse('$_apiUrl/showtasks'),
//   //     headers: {
//   //       'Content-Type': 'application/json',
//   //     },
//   //     body: jsonEncode({'taskName': taskName, 'taskDescription': taskDescription}),
//   //   );

//   //   if (response.statusCode == 201) {
//   //     final dynamic json = jsonDecode(response.body);
//   //     final Tasks task = Tasks.fromJson(json);
//   //     return task;
//   //   } else {
//   //     throw Exception('Failed to add task');
//   //   }
//   // }

//   Future<void> updateTask(int taskId, String taskName, String taskDescription) async {
//     final response = await http.put(
//       Uri.parse('$_apiUrl/showtasks/$taskId'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'taskName': taskName, 'taskDescription': taskDescription}),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to update task');
//     }
//   }

//   Future<void> deleteTask(int taskId) async {
//     final response = await http.delete(
//       Uri.parse('$_apiUrl/showtasks/$taskId'),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete task');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Example list of tasks

//     return Column(
//       children: [
//         FutureBuilder(
//           future: fetchTasks(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   final item = snapshot.data![index];
//                       return GestureDetector(
//                     onTap: () {
//                       print(
//                           'Tap'); // Handle tap on the task here, you can navigate to another screen or perform any action
//                     },
//                     //child: Container(
//                     // width: 148.0,
//                     // height: 100.0,
//                     // decoration: BoxDecoration(
//                     //   borderRadius: BorderRadius.circular(20.0),
//                     //   //color: Color.fromARGB(255, 40, 8, 184),
//                     //   border: Border.all(
//                     //     color: Color.fromARGB(255, 0, 0, 0),
//                     //     width: 1.0,
//                     //   ),
//                     // ),
//                     child: ListTile(
//                       title: Text(item.taskName!),
//                       subtitle: Text(item.taskDescription!),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       title: Text('Delete Task'),
//                                       content: Text(
//                                           'Are you sure you want to delete this task?'),
//                                       actions: [
//                                         TextButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text('Cancel')),
//                                         TextButton(
//                                             onPressed: () async {
//                                               await deleteTask(item.taskId!);
//                                               setState(() {});
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text('Yes'))
//                                       ],
//                                     );
//                                   });
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.edit),
//                             onPressed: () {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       title: Text('Edit Task'),
//                                       content: Column(
//                                         children: [
//                                           TextFormField(
//                                               controller: _taskNameController,
//                                               decoration: InputDecoration(
//                                                 labelText: 'Edit Task Name',
//                                               )),
//                                           TextFormField(
//                                               controller: _taskDescriptionController,
//                                               decoration: InputDecoration(
//                                                 labelText: 'Edit Task Description',
//                                               )),
//                                         ],
//                                       ),
                                          
//                                       actions: [
//                                         TextButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text('Cancel')),
//                                         TextButton(
//                                             onPressed: () {
//                                               updateTask(item.taskId!,
//                                                   _taskNameController.text, _taskDescriptionController.text);
//                                               setState(() {
//                                                 _taskNameController.clear();
//                                                 _taskDescriptionController.clear();
//                                               });
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text('Edit'))
//                                       ],
//                                     );
//                                   });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     //),
//                   );
                  
                  
//                 },
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text(snapshot.error.toString()),
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//         // FloatingActionButton(
//         //   onPressed: () {
//         //     showDialog(
//         //         context: context,
//         //         barrierDismissible: false,
//         //         builder: (context) {
//         //           return AlertDialog(
//         //             title: Text('Add Task'),
//         //             content: TextFormField(
//         //                 controller: _taskNameController,
//         //                 decoration: InputDecoration(
//         //                   labelText: 'Add Task Name',
//         //                 )),
//         //             actions: [
//         //               TextButton(
//         //                   onPressed: () {
//         //                     Navigator.pop(context);
//         //                   },
//         //                   child: Text('Cancel')),
//         //               TextButton(
//         //                   onPressed: () {
//         //                     addTask(_taskNameController.text, _taskDescriptionController.text);
//         //                     setState(() {
//         //                       _taskNameController.clear();
//         //                     });
//         //                     Navigator.pop(context);
//         //                   },
//         //                   child: Text('Add'))
//         //             ],
//         //           );
//         //         });
//         //   },
//         //   tooltip: 'Add Task',
//         //   child: Icon(Icons.add),
//         // )
//       ],
//     );
//   }
// }
