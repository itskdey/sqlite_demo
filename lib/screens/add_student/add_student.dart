import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_demo/service/db_helper.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  String gender = "";
  String dob = "";
  int id = 0;
  String profile = "";

  var nameCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();

  bool isUpdate = true;
  bool isInit = true;

  void dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(title: Text("Uploading"));
      },
    );
  }

  void addStundent() async {
    var checkCondition =
        nameCtrl.text.isNotEmpty && dob.isNotEmpty && gender.isNotEmpty;

    if (checkCondition) {
      final cloudinary = CloudinaryPublic('', '', cache: false);

      var uploadImage = "";

      if (profile.isNotEmpty) {
        try {
          dialog();
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              profile,
              resourceType: CloudinaryResourceType.Image,
            ),
          );

          Navigator.pop(context);

          debugPrint(response.secureUrl);

          setState(() {
            uploadImage = response.secureUrl;
          });
        } on CloudinaryException catch (e) {
          debugPrint(e.message);
        }
      }

      DbHelper().insertStudent(
        name: nameCtrl.text,
        dob: dob,
        gender: gender,
        email: emailCtrl.text,
        phone: phoneCtrl.text,
        profile: uploadImage,
      );

      setState(() {
        nameCtrl.clear();
        emailCtrl.clear();
        phoneCtrl.clear();
        gender = "";
        dob = "";
        profile = "";
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Insert Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Full Name, gender & dob is empty")),
      );
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    var data = ModalRoute.of(context)!.settings.arguments;

    debugPrint("Data from home : $data");

    if (isInit) {
      if (data == null) {
        setState(() {
          isUpdate = false;
        });
      } else {
        data as Map;

        id = data["id"];
        nameCtrl.text = data["full_name"];
        gender = data["gender"];
        dob = data["dob"];
        emailCtrl.text = data["email"];
        phoneCtrl.text = data["phone"];
        profile = data["profile"];
      }
    }

    isInit = false;

    debugPrint("Did change");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(isUpdate ? "Update Student" : "Add Student"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo(),
            SizedBox(height: 20),
            _buildPersonalInfo(),
            SizedBox(height: 20),
            _buildContactInfo(),
            Spacer(),
            _buildBtn(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1.5),
            ),
            child: Center(child: Text("Cancel")),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () async {
              if (isUpdate) {
                final cloudinary = CloudinaryPublic(
                  'kdey',
                  'student_profile',
                  cache: false,
                );

                var uploadImage = "";

                try {
                  dialog();
                  CloudinaryResponse response = await cloudinary.uploadFile(
                    CloudinaryFile.fromFile(
                      profile,
                      resourceType: CloudinaryResourceType.Image,
                    ),
                  );

                  Navigator.pop(context);

                  debugPrint(response.secureUrl);

                  setState(() {
                    uploadImage = response.secureUrl;
                  });
                } on CloudinaryException catch (e) {
                  debugPrint(e.message);
                }

                DbHelper().updateStudent(
                  id: id,
                  name: nameCtrl.text,
                  dob: dob,
                  gender: gender,
                  email: emailCtrl.text,
                  phone: phoneCtrl.text,
                  profile: uploadImage,
                );

                Navigator.pop(context);
              } else {
                addStundent();
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xffd1e4e2),
              ),
              child: Center(
                child: Text(isUpdate ? "Update Student" : "Add Student"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Information",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _customTextfield(
          text: "Email",
          icon: Icon(Icons.email_outlined),
          controller: emailCtrl,
        ),
        SizedBox(height: 10),
        _customTextfield(
          text: "Phone Number",
          icon: Icon(Icons.phone_outlined),
          controller: phoneCtrl,
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Information",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        _customTextfield(
          text: "Full Name",
          icon: Icon(Icons.person_outline),
          controller: nameCtrl,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: PopupMenuButton(
                position: PopupMenuPosition.under,
                color: Colors.white,
                onSelected: (value) {
                  debugPrint("Value : $value");
                  setState(() {
                    gender = value;
                  });
                },

                itemBuilder: (context) {
                  return [
                    PopupMenuItem(value: "Male", child: Text("Male")),
                    PopupMenuItem(value: "Female", child: Text("Female")),
                    PopupMenuItem(value: "Other", child: Text("Other")),
                  ];
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 55,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.people_outline),
                      SizedBox(width: 10),
                      Text(gender.isEmpty ? "Select Gender" : gender),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  ).then((value) {
                    debugPrint("Date selected : $value");
                    setState(() {
                      dob = "${value!.month}-${value.day}-${value.year}";
                    });
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 55,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_outlined),
                      SizedBox(width: 10),
                      Text(dob.isEmpty ? "Select DOB" : dob),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _customTextfield({
    required String text,
    required Icon icon,
    required TextEditingController controller,
  }) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: icon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            var imagePath = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );

            setState(() {
              profile = imagePath!.path;
            });
          },
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: isUpdate && profile.startsWith("http")
                    ? Image.network(profile)
                    : Image.file(
                        File(profile),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            SizedBox(),
                      ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffd1e4e2),
                  ),
                  child: Center(child: Icon(Icons.add, size: 20)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "No Class",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}


// upload image into cloud storage 
// display network
// apiKey - uesername - apiSecret