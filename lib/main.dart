import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  late String name;
  late String studentId;
  late String programId;
  late String cgpa;

  void create(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('students').doc(name);
     Map<String,dynamic> students = {
      "studentName":name,
      "studentCGPA":cgpa,
       "studentId":studentId,
       "studyProgramId":programId
    };
     documentReference.set(students).whenComplete(() => debugPrint('$name created'));
  }

  void read(){
    FirebaseFirestore.instance
        .collection('students')
        .doc(name)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void update(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('students').doc(name);
    Map<String,dynamic> students = {
      "studentName":name,
      "studentCGPA":cgpa,
      "studentId":studentId,
      "studyProgramId":programId
    };
    documentReference.set(students).whenComplete(() => debugPrint('$name updated'));
  }

  void delete(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('students').doc(name);
    documentReference.delete().whenComplete(() => debugPrint('$name is deleted'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Database'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Field('Name',(String value){name=value;}),
              const SizedBox(
                height: 10.0,
              ),
              Field('Student Id',(String value){studentId=value;}),
              const SizedBox(
                height: 10.0,
              ),
              Field('Program Id',(String value){programId=value;}),
              const SizedBox(
                height: 10.0,
              ),
              Field('CGPA',(String value){cgpa=value;}),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: create,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red),
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15))), child: const Text('Create'),),
                  ElevatedButton(onPressed: read,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green),
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15))), child: const Text('Read'),),
                  ElevatedButton(onPressed: update,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15))), child: const Text('Update'),),
                  ElevatedButton(onPressed: delete,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange),
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15))), child: const Text('Delete'),),
                ],
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('students').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: null,
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Field extends StatelessWidget {

  final String text;
  final void Function(String)? onChanged;

  Field(this.text,this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: text,
          fillColor: Colors.white,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
