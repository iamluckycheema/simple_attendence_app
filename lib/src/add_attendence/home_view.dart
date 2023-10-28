import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import '../settings/settings_view.dart';
import 'package:pdf/widgets.dart' as pdf_lib;

class AddAttendanceScreen extends StatefulWidget {
  static const routeName = '/';
  const AddAttendanceScreen({super.key});
  @override
  State<AddAttendanceScreen> createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  String roomNumber = '';
  String selectedTimeSlot = 'Select Slot';
  DateTime selectedDate = DateTime.now();
  String selectedSubject = 'Select Subject';

  final TextEditingController _controller = TextEditingController();

  // Simulated list of students
  List<String> students = [
    '20011556-002',
    '20011556-003',
    '20011556-005',
    '20011556-006',
    '20011556-007',
    '20011556-008',
    '20011556-011',
    '20011556-013',
    '20011556-014',
    '20011556-015',
    '20011556-018',
    '20011556-019',
    '20011556-023',
    '20011556-024',
    '20011556-025',
    '20011556-027',
    '20011556-028',
    '20011556-029',
    '20011556-030',
    '20011556-034',
    '20011556-035',
    '20011556-036',
    '20011556-037',
    '20011556-038',
    '20011556-039',
    '20011556-041',
    '20011556-042',
    '20011556-043',
    '20011556-044',
    '20011556-045',
    '20011556-046',
    '20011556-047',
    '20011556-102',
    '20011556-143',
    '20011556-159',
  ];

  // Keep track of student attendance using a map
  Map<String, bool> studentAttendance = {};

  @override
  void initState() {
    super.initState();
    for (var student in students) {
      studentAttendance[student] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const headingStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    var decorationBorder = BoxDecoration(
      border: Border.all(
        width: 2.0,
        color: const Color(0xff425884),
      ),
      borderRadius: BorderRadius.circular(10),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Lucky!'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                roomNumber = '';
                _controller.text = "";
                selectedTimeSlot = 'Select Slot';
                selectedDate = DateTime.now();
                selectedSubject = 'Select Subject';
                for (var student in students) {
                  studentAttendance[student] = false;
                }
              });
            },
            icon: const Icon(Icons.restore),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "Room Number:",
                style: headingStyle,
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter Room Number',
                hintStyle: const TextStyle(
                  fontSize: 16,
                ),
                fillColor: Colors.transparent,
                filled: true,
                suffixIcon: const Icon(
                  Icons.home,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xff425884),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xff425884),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  roomNumber = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "Time Slot:",
                style: headingStyle,
              ),
            ),
            Container(
              height: 60,
              decoration: decorationBorder,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    isExpanded: true,
                    icon: const Icon(Icons.watch),
                    value: selectedTimeSlot,
                    items: <String>[
                      'Select Slot',
                      '08:45AM - 10:15AM',
                      '10:15AM - 11:45AM',
                      '11:45AM - 01:15PM',
                      '01:30PM - 03:00PM',
                      '03:00PM - 04:30PM',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTimeSlot = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "Date:",
                style: headingStyle,
              ),
            ),
            Container(
              height: 60,
              decoration: decorationBorder,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        ).then((pickedDate) {
                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        });
                      },
                      child: const Text(
                        'Select Date',
                        style: headingStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "Subject:",
                style: headingStyle,
              ),
            ),
            Container(
              height: 60,
              decoration: decorationBorder,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSubject,
                    isExpanded: true,
                    icon: const Icon(Icons.book),
                    items: <String>[
                      'Select Subject',
                      'IT Project Managment',
                      'Operation Research',
                      'Cyber Security',
                      'Data Mining',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubject = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                'Student Attendance:',
                style: headingStyle,
              ),
            ),
            Container(
              decoration: decorationBorder,
              child: Column(
                children: students.map((student) {
                  return CheckboxListTile(
                    title: Text(student),
                    value: studentAttendance[student] ?? false,
                    onChanged: (value) {
                      setState(() {
                        studentAttendance[student] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    decoration: decorationBorder,
                    child: SizedBox(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          _saveAttendance();
                        },
                        child: const Text(
                          'Save',
                          style: headingStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    decoration: decorationBorder,
                    child: SizedBox(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          _printDocument();
                        },
                        child: const Text(
                          'Print',
                          style: headingStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    decoration: decorationBorder,
                    child: SizedBox(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          _shareDocument();
                        },
                        child: const Text(
                          'Share',
                          style: headingStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveAttendance() async {
    pdf_lib.Document doc = _makeDoc();
    //asking for permission if not already available
    var status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      await [Permission.manageExternalStorage].request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    //getting file directory using path_provider
    Directory? directory = await getApplicationDocumentsDirectory();

    //create /Attendence folder if doesnot exist already
    final attendanceDirectory = Directory('${directory.path}/Attendence');
    if (!attendanceDirectory.existsSync()) {
      attendanceDirectory.createSync();
    }

    //naming the file and saving in given path
    var fileName = "$selectedSubject ${selectedDate.toLocal()}.pdf";
    var filePath = "${attendanceDirectory.path}/$fileName";

    final File pdfFile = File(filePath);

    await pdfFile.writeAsBytes(await doc.save()).then(
          (value) => {
            ////showing a toast that file is saved
            _showToast(filePath)
          },
        );
  }

  void _printDocument() async {
    pdf_lib.Document doc = _makeDoc();
    //printing document andoid/ios printing service
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  void _showToast(String filePath) {
    Fluttertoast.showToast(
      msg: 'File saved as $filePath',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  pdf_lib.Document _makeDoc() {
    //creating document
    final pdf_lib.Document doc = pdf_lib.Document();

    //formatting the Map<String,bool> to dispaly correctly, seperating present and absent students
    //may change to list.
    String presentStudents = 'Present Students:\n';
    String absentStudents = 'Absent Students:\n';

    studentAttendance.forEach((student, isPresent) {
      if (isPresent) {
        presentStudents += '$student: ${isPresent ? 'Present' : 'Absent'}\n';
      } else {
        absentStudents += '$student: ${isPresent ? 'Present' : 'Absent'}\n';
      }
    });

    //adding content to document
    doc.addPage(
      pdf_lib.MultiPage(
        orientation: pdf_lib.PageOrientation.portrait,
        crossAxisAlignment: pdf_lib.CrossAxisAlignment.start,

        //foramtting header
        header: (pdf_lib.Context context) {
          if (context.pageNumber == 1) {
            return pdf_lib.SizedBox();
          }
          return pdf_lib.Container(
              alignment: pdf_lib.Alignment.centerRight,
              margin:
                  const pdf_lib.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding:
                  const pdf_lib.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pdf_lib.BoxDecoration(
                  border: pdf_lib.Border(
                      bottom: pdf_lib.BorderSide(
                          width: 0.5, color: PdfColors.grey))),
              child: pdf_lib.Text(selectedSubject,
                  style: pdf_lib.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },

        //page number in footer
        footer: (pdf_lib.Context context) {
          return pdf_lib.Container(
              alignment: pdf_lib.Alignment.centerRight,
              margin:
                  const pdf_lib.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pdf_lib.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pdf_lib.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },

        //main page content
        build: (pdf_lib.Context context) => <pdf_lib.Widget>[
          pdf_lib.Header(
              level: 0,
              title: 'Attendence Report',
              child: pdf_lib.Row(
                  mainAxisAlignment: pdf_lib.MainAxisAlignment.spaceBetween,
                  children: <pdf_lib.Widget>[
                    pdf_lib.Text('Attendence Report', textScaleFactor: 2),
                    pdf_lib.PdfLogo()
                  ])),
          pdf_lib.Paragraph(
            text:
                'Subject: $selectedSubject\n\nRoom Number: $roomNumber\nTime Slot: $selectedTimeSlot\nDate: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}\n\n$presentStudents\n\n$absentStudents',
            style: const pdf_lib.TextStyle(fontSize: 18.0),
          ),
          pdf_lib.Padding(padding: const pdf_lib.EdgeInsets.all(10)),
          pdf_lib.Paragraph(text: '2023 © Lucky Ali')
        ],
      ),
    );
    return doc;
  }

  void _shareDocument() async {
    pdf_lib.Document doc = _makeDoc();
    await Printing.sharePdf(
        bytes: await doc.save(),
        filename: '$selectedSubject ${selectedDate.toLocal()}.pdf');
  }
}
