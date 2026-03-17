// 1- find database path
// 2- create database

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? db;

  Future<String> _getLocalPath() async {
    var path = await getDatabasesPath();
    return path;
  }

  Future<Database> _initDB() async {
    var dbFile = join(await _getLocalPath(), "student.db");
    // var dbFile = "${await _getLocalPath()}/student.db";

    return openDatabase(
      dbFile,
      version: 2,
      onCreate: (db, version) {
        db.execute(""" 
          CREATE TABLE "tb_student" (
          	"id"	INTEGER NOT NULL UNIQUE,
          	"full_name"	TEXT NOT NULL,
          	"dob"	TEXT NOT NULL,
          	"gender"	TEXT NOT NULL,
          	"email"	TEXT NOT NULL,
          	"phone"	TEXT NOT NULL,
          	"profile"	TEXT,
          	PRIMARY KEY("id" AUTOINCREMENT)
          );
        """);
      },
    );
  }

  Future<Database> _openDB() async {
    if (db != null) {
      return db!;
    } else {
      return await _initDB();
    }
  }

  //crud operations : create, read, update, delete
  //create or insert
  void insertStudent({
    required String name,
    required String dob,
    required String gender,
    required String email,
    required String phone,
    required String profile,
  }) async {
    var database = await _openDB();
    database.insert("tb_student", {
      "full_name": name,
      "dob": dob,
      "gender": gender,
      "email": email,
      "phone": phone,
      "profile": profile,
    });
    //INSERT INTO table(...) VALUES(...)
  }

  //read
  Future<List<Map<String, dynamic>>> readStudent() async {
    var database = await _openDB();
    var data = await database.query("tb_student");
    debugPrint("data from db = $data");
    return data;
    //SELECT * FROM table;
  }

  //delete
  void deletStudent(int id) async {
    var database = await _openDB();
    database.delete("tb_student", where: "id = ?", whereArgs: [id]);
  }

  void updateStudent({
    required int id,
    required String name,
    required String dob,
    required String gender,
    required String email,
    required String phone,
    required String profile,
  }) async {
    var database = await _openDB();
    database.update(
      "tb_student",
      {
        "full_name": name,
        "dob": dob,
        "gender": gender,
        "email": email,
        "phone": phone,
        "profile": profile,
      },
      where: "id = ?",
      whereArgs: [id],
    );
    //INSERT INTO table(...) VALUES(...)
  }
}

//where clause// where condition
//where id =3
//1 == 1
