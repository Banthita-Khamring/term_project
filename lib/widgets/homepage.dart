import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:term_project/widgets/add_task_page.dart';
import 'package:term_project/model/tasks.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchTasks(_selectedDate);
  }

  DateTime _selectedDate = DateTime.now();

  final String _apiUrl = 'http://localhost:3000';
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();

// เรียกข้อมูล tasks จาก server โดยใช้ HTTP GET request โดยส่ง parameter เป็นวันที่ที่ต้องการ (selectedDate) เพื่อแสดง task เฉพาะของวันนั้นๆ
  Future<List<Tasks>> fetchTasks(DateTime selectedDate) async {
    final response = await http.get(
      Uri.parse(// for instance http://localhost:3000/showtasks?date=4/10/2024
          '$_apiUrl/showtasks?date=${DateFormat('M/d/yyyy').format(selectedDate)}'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> itemtasks = json.decode(response.body);
      final List<Tasks> items = itemtasks.map((item) {
        return Tasks.fromJson(item);
      }).toList();
      return items;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

// --------------------------------------------------------------------------
// ใช้ในการอัปเดตข้อมูล tasks โดยใช้ HTTP PUT request ส่งข้อมูลที่ต้องการอัปเดตไป server โดยส่ง parameter taskId, taskName, taskDescription, date
  Future<void> updateTask(
      int taskId, String taskName, String taskDescription, String date) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/showtasks/$taskId'),
      headers: {
        // ระบุว่าข้อมูลที่ส่งไปคือ JSON
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'taskName': taskName,
        'taskDescription': taskDescription,
        'date': date.toString(),
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }
// -------------------------------------------------------------------

// ฟังก์ชันที่ใช้ในการลบ tasks โดยใช้ HTTP DELETE request เพื่อส่งคำขอลบข้อมูลงานที่ต้องการไปยัง server  และระบุ taskId ที่ต้องการลบใน URI ด้วย
  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$_apiUrl/showtasks/$taskId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
  // -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Icon(
                  Icons.work_outline_outlined,
                  size: 32.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Today\'s Tasks',
                  style: GoogleFonts.cuprum(
                    fontSize: 36.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          showListTile(),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  Container _addTaskBar() {
    // ส่วนของการแสดงวันที่และปุ่ม + new task
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.today_outlined,
                      size: 40.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      DateFormat.yMMMMd().format(  // รูปแบบ Apr 15, 2024
                          _selectedDate), // (_selectedDate is today) แสดงวันที่เป็นวันที่ปัจจุบัน
                      style: GoogleFonts.cuprum(fontSize: 60.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _addButton(), // สร้างปุ่ม + new task
        ],
      ),
      // Set background color of the task bar based on the selected date
    );
  }

  // ---------------------------------------------------------
  Material _addButton() {
    // สร้างปุ่ม + new task
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              // เมื่อกดแล้วจะไปที่หน้า AddTaskPage 
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage()));
        },
        splashColor: Color.fromARGB(255, 83, 212, 255),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Ink(
          width: 130.0,
          height: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Color.fromARGB(255, 40, 8, 184),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              '+ New Task',
              textAlign: TextAlign.center,
              style: GoogleFonts.cuprum(
                  textStyle: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 5, 99, 181),
              )),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  Container _addDateBar() {
    // ส่วนของการแสดงวันที่ เดือน โดยใช้ DatePicker
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 28.0),
      child: DatePicker(
        DateTime.now(),
        height: 120.0,
        width: 80.0,
        initialSelectedDate: DateTime
            .now(), // ใช้ DateTime.now() เพื่อเริ่มแสดงวันที่ปัจจุบันเป็นต้นไป
        selectionColor: getTaskBarColor(
            _selectedDate), // เมื่อมีการกดเลือกวันที่นั้นๆ จะแสดงสีตามวันนั้นๆ
        dateTextStyle: GoogleFonts.cuprum(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 255, 105, 105)),
        monthTextStyle: GoogleFonts.lato(
            fontSize: 10.0, color: Color.fromARGB(255, 146, 150, 163)),
        dayTextStyle: GoogleFonts.lato(
            fontSize: 12.0, color: Color.fromARGB(255, 100, 137, 255)),
        onDateChange: (selectedDate) {
          setState(() {
            _selectedDate = selectedDate; // Update selected date
            // please call showtasks() function to fetch tasks based on selected date
          }); // Fetch tasks based on selected date
        },
      ),
    );
  }

// ----------------------------------------------------
  Color getTaskBarColor(DateTime selectedDate) {
    // แสดงสีตามวันนั้นๆ ตามลำดับ
    switch (selectedDate.weekday) {
      case DateTime.sunday:
        return Color.fromARGB(255, 249, 140, 132);
      case DateTime.monday:
        return Color.fromARGB(255, 244, 233, 136);
      case DateTime.tuesday:
        return Color.fromARGB(255, 251, 126, 168);
      case DateTime.wednesday:
        return Color.fromARGB(255, 144, 217, 147);
      case DateTime.thursday:
        return Color.fromARGB(255, 234, 183, 106);
      case DateTime.friday:
        return Color.fromARGB(255, 136, 186, 227);
      case DateTime.saturday:
        return Color.fromARGB(255, 208, 133, 216);
      default:
        return Colors.grey; // Default color
    }
  }

// ----------------------------------------------------
  FutureBuilder<List<Tasks>> showListTile() {
    return FutureBuilder(
      future: fetchTasks(_selectedDate), // Pass the selected date to fetchTasks
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // ข้อความที่แสดงเมื่อไม่มีงาน ของวันนั้น
                "No tasks for today",
                style: GoogleFonts.cuprum(
                  fontSize: 30.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              Icon(
                Icons.thumb_up_alt_outlined,
                size: 30.0,
                color: getTaskBarColor(_selectedDate),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              // ส่วนแสดงงาน ของวันนั้นๆ
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: getTaskBarColor(_selectedDate), width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    title: RichText(
                      maxLines: 2, // จำกวนแสดง 2 บรรทัด
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: '${item.taskName!}\n', // แสดงชื่อ
                        style: GoogleFonts.cuprum(
                            fontSize: 34.0,
                            color: Color.fromARGB(255, 40, 8, 184),
                            fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: item.taskDescription!, // รายละเอียดของานนั้น
                            style: GoogleFonts.cuprum(
                              fontSize: 28.0,
                              color: Color.fromARGB(255, 185, 183, 183),
                            ),
                          )
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(   // <----------------------------------------------------
                          icon: Icon(
                            Icons
                                .expand_circle_down_outlined, // ถ้ามีรายละเอียดมากกว่า 2 บรรทัด กดดูรายละเอียดงานได้
                            color: Color.fromARGB(255, 40, 8, 184),
                            size: 36.0,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: AlertDialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 251, 236),
                                    title: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 251, 233),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${item.taskName!}',
                                            style: GoogleFonts.cuprum(
                                              fontSize: 38.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 40, 8, 184),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.cancel_outlined,
                                              size: 44.0,
                                              color: Color.fromARGB(
                                                  255, 255, 39, 39),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    content: Column(
                                      children: [
                                        Text(
                                          '${item.taskDescription!}',
                                          style: GoogleFonts.cuprum(
                                            fontSize: 28.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        IconButton(   // <----------------------------------------------------
                          icon: Icon(
                            Icons
                                .edit_note_rounded, // กดเพื่อแสดง dialog แก้ไขงาน
                            color: Colors.black,
                            size: 38.0,
                          ),
                          onPressed: () {
                            // Show edit dialog
                            _showEditDialog(item); // Dialog แก้ไขงาน
                          },
                        ),
                        IconButton(
                          icon: Icon(  // <----------------------------------------------------
                            Icons.delete_forever, // กดเพื่อลบงาน
                            color: Colors.black,
                            size: 34.0,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 195, 195),
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.red,
                                    size: 40.0,
                                  ),
                                  title: Text(
                                    'Are you sure you want to delete?',
                                    style: GoogleFonts.cuprum(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await deleteTask(item.taskId!);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 100, 198, 85)),
                                        child: Text(
                                          'Yes',
                                          style: GoogleFonts.cuprum(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 230, 122, 76)),
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
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

// ----------------------------------------------
// Dialog แก้ไขงาน
  void _showEditDialog(Tasks task) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          child: Dialog(
            backgroundColor: Color.fromARGB(255, 225, 255, 228),
            insetPadding: EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 217, 236, 255),
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10.0),
                              Text(
                                'Edit',
                                style: GoogleFonts.cuprum(
                                  color: Color.fromARGB(255, 40, 8, 184),
                                  fontSize: 38.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                size: 36.0,
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.check_circle_outlined,
                              size: 54.0,
                              color: Color.fromARGB(255, 80, 220, 59),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 195, 195),
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: const Color.fromARGB(
                                            255, 255, 75, 62),
                                        size: 40.0,
                                      ),
                                      title: Text(
                                        'Are you sure you want to edit?',
                                        style: GoogleFonts.mali(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              updateTask(
                                                task.taskId!, // เปลี่ยนแปลงข้อมูลที่แก้ไข
                                                _taskNameController.text,
                                                _taskDescriptionController.text,
                                                DateFormat.yMd()
                                                    .format(_selectedDate),
                                              ); // 4/21/2024 M/D/YYYY
                                              setState(() {
                                                _taskNameController.clear();
                                                _taskDescriptionController
                                                    .clear();
                                                print(
                                                    'tasks.date ${task.date}');
                                                print(
                                                    '_selectedDate ${_selectedDate}');
                                                print(
                                                    'format ${DateFormat.yMd().format(_selectedDate)}');
                                              });
                                              if (task.date !=
                                                  DateFormat.yMd()
                                                      .format(_selectedDate)) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyHomePage()));
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 100, 198, 85)),
                                            child: Text(
                                              'Yes', // ยืนยันการแก้ไข
                                              style: GoogleFonts.mali(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 230, 122, 76)),
                                            child: Text(
                                              'Cancle',
                                              style: GoogleFonts.mali(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.cancel_outlined,
                                size: 54.0,
                                color: Color.fromARGB(255, 255, 39, 39),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.only(left: 28.0),
                      child: Text(
                        'Task Name',
                        style: GoogleFonts.cuprum(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.only(left: 28.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: _taskNameController
                          ..text = task.taskName ?? '',
                        maxLines: null,
                        autofocus: true,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 28.0),
                      child: Text(
                        'Task Description',
                        style: GoogleFonts.cuprum(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.only(left: 28.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: _taskDescriptionController
                          ..text = task.taskDescription ?? '',
                        maxLines: null,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 28.0),
                      child: Text(
                        'Due Date',
                        style: GoogleFonts.cuprum(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Container(
                      margin: EdgeInsets.only(left: 28.0),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// -------------------------------------------------
  _getDateFromUser() async {
    // เปลี่ยน ค่า _selectedDate ให้เป็นวันที่ที่กดเลือก
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));

    if (_pickerDate != null) {
      setState(() {
        print(_selectedDate);

        _selectedDate = _pickerDate;
        print('-------------');
        print(_selectedDate);
      });
    } else {
      print('Date is not selected');
    }
  }
}
