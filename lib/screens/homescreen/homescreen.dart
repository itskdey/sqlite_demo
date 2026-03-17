import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqlite_demo/service/db_helper.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var studentData = [];

  void _loadData() async {
    var data = await DbHelper().readStudent();
    setState(() {
      studentData = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Homescreen")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addStudent").then((value) {
            _loadData();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemCount: studentData.length,
          itemBuilder: (context, index) {
            return _buildStudentItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildStudentItem(int index) {
    var isSplit = studentData[index]["full_name"].contains(" ");
    var fullName = studentData[index]["full_name"].split(" ");
    var splittedName = isSplit
        ? "${fullName[0][0]}${fullName[1][0]}"
        : studentData[index]["full_name"][0];

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.amber,
          radius: 30,
          onBackgroundImageError: (exception, stackTrace) => SizedBox(),
          backgroundImage: NetworkImage(studentData[index]["profile"]),
          child: studentData[index]["profile"].isEmpty
              ? Text("$splittedName")
              : SizedBox(),
        ),
        SizedBox(width: 10),

        ///
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentData[index]["full_name"].toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "DOB : ${studentData[index]["dob"]}",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),

            ///
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),

              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                studentData[index]["gender"],
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),

        ///
        Spacer(),
        PopupMenuButton(
          color: Colors.white,
          position: PopupMenuPosition.under,
          onSelected: (value) {
            if (value == 0) {
              Navigator.pushNamed(
                context,
                "/addStudent",
                arguments: studentData[index],
              ).then((value) {
                _loadData();
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Update is clicked")));
            } else {
              DbHelper().deletStudent(studentData[index]["id"]);
              _loadData();

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Delete is clicked")));
            }
          },

          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text('Update Student'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Delete Student', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ];
          },
          child: Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}

// Widget -> Image.asset, .network .file
// ImageProvider  -> AssetImage, NetworkImage, FileImage
// container -> decoration - image -> image provider
// container -> child -> widget
