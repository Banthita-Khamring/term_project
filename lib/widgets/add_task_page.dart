import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:term_project/widgets/homepage.dart';
import 'package:term_project/model/tasks.dart';
import 'package:http/http.dart' as http;

// หน้าเพิ่ม TAsk
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

final String _apiUrl = 'http://localhost:3000';
final _taskNameController = TextEditingController();
final _taskDescriptionController = TextEditingController();

Future<Tasks> addTask(
    String taskName, String taskDescription, String date) async {
  final response = await http.post(
    Uri.parse('$_apiUrl/showtasks'),
    headers: {
      'Content-Type': 'application/json',
    },
    // add อะไรบ้าง
    body: jsonEncode({
      'taskName': taskName,
      'taskDescription': taskDescription,
      'date': date.toString(),
    }),
  );

  if (response.statusCode == 201) {
    final dynamic json = jsonDecode(response.body);
    final Tasks task = Tasks.fromJson(json);
    return task;
  } else {
    throw Exception('Failed to add task');
  }
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Task Todo',
          style: GoogleFonts.cuprum(
            fontSize: 42.0,
            color: Color.fromARGB(255, 40, 8, 184),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        //color: Colors.blue,
        margin: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check_circle_outlined,
                      size: 56.0,
                      color: Color.fromARGB(255, 80, 220, 59),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Color.fromARGB(255, 255, 195, 195),
                            icon: Icon(
                              Icons.info_outline,
                              color: const Color.fromARGB(255, 255, 75, 62),
                              size: 40.0,
                            ),
                            title: Text(
                              'Are you sure you want to add?',
                              style: GoogleFonts.cuprum(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    addTask(
                                        _taskNameController
                                            .text, // date เป็น วันนั้น (ถ้าไม่ได้เลือก)
                                        _taskDescriptionController.text,
                                        DateFormat.yMd().format(_selectedDate));
                                    setState(() {
                                      _taskNameController.clear();
                                      _taskDescriptionController.clear();
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 100, 198, 85)),
                                  child: Text(
                                    'Yes',
                                    style: GoogleFonts.cuprum(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 230, 122, 76)),
                                  child: Text(
                                    'Cancle',
                                    style: GoogleFonts.cuprum(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: 56.0,
                      color: Color.fromARGB(255, 255, 39, 39),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Task Name',
                  style: GoogleFonts.cuprum(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _taskNameController,
                  autofocus: true,
                  decoration: InputDecoration(//<------------------------------------------
                    hintText: 'Enter Task Name',
                    hintStyle: GoogleFonts.cuprum(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Task Description',
                  style: GoogleFonts.cuprum(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField( //<------------------------------------------
                  controller: _taskDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter Description',
                    hintStyle: GoogleFonts.cuprum(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text( //<------------------------------------------
                  'Due Date',
                  style: GoogleFonts.cuprum(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: IconButton(  
                    icon: Icon(
                      Icons.edit_calendar_outlined,
                      color: Color.fromARGB(255, 171, 169, 176),
                      size: 46.0,
                    ),
                    onPressed: () {
                      debugPrint('Calender');
                      _getDateFromUser();
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              )
            ],
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print('Date is not selected');
    }
  }
}
