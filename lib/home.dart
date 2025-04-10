import 'package:flutter/material.dart';
import 'package:flutter_sqlite/sql_management/model_students.dart';
import 'package:flutter_sqlite/sql_management/database.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DataBase handler;
  Future<int> addStudents() async {
    Students firstStudent = Students(
      id: 0,
      firstName: "Jan",
      lastName: "Kaczka",
      studentsYear: 1,
    );
    Students secondStudent = Students(
      id: 1,
      firstName: "Adam",
      lastName: "Zakrzaczki",
      studentsYear: 3,
    );
    Students thirdStudent = Students(
      id: 2,
      firstName: "Aleksandra",
      lastName: "Brzozowaska",
      studentsYear: 3,
    );
    Students fourthStudent = Students(
      id: 3,
      firstName: "Anna",
      lastName: "Mruk",
      studentsYear: 2,
    );

    List<Students> students = [
      firstStudent,
      secondStudent,
      thirdStudent,
      fourthStudent,
    ];
    return await handler.insertStudents(students);
  }

  @override
  void initState() {
    super.initState();
    handler = DataBase();
    handler.initializedDB().whenComplete(() async {
      await addStudents();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: handler.retrieveStudents(),
        builder: (
            BuildContext context,
            AsyncSnapshot<List<Students>> snapshot,
            ) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(
                      '${snapshot.data![index].firstName} ${snapshot.data![index].lastName}',
                    ),
                    subtitle: Text(
                      'Rok ${snapshot.data![index].studentsYear.toString()}',
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
