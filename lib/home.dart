import 'package:flutter/material.dart';
import 'package:flutter_sqlite/add_student.dart';
import 'package:flutter_sqlite/sql_management/database.dart';
import 'package:flutter_sqlite/sql_management/model_students.dart';
import 'package:provider/provider.dart';

import 'theme_controller.dart';

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
    Students fifthStudent = Students(
      id: 4,
      firstName: "Żaneta",
      lastName: "Bąbel",
      studentsYear: 3,
    );
    Students sixthStudent = Students(
      id: 5,
      firstName: "Miłosz",
      lastName: "Baran",
      studentsYear: 5,
    );
    Students seventhStudent = Students(
      id: 6,
      firstName: "Agnieszka",
      lastName: "Rozkosz",
      studentsYear: 5,
    );
    Students eighthStudent = Students(
      id: 7,
      firstName: "Robert",
      lastName: "Prawowski",
      studentsYear: 5,
    );

    List<Students> students = [
      firstStudent,
      secondStudent,
      thirdStudent,
      fourthStudent,
      fifthStudent,
      sixthStudent,
      seventhStudent,
      eighthStudent,
    ];
    return await handler.insertStudents(students);
  }

  @override
  void initState() {
    super.initState();
    handler = DataBase();
    handler.initializedDB().whenComplete(() async {
      List<Students> existing = await handler.retrieveStudents();
      if (existing.isEmpty) {
        await addStudents();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
        elevation: 3,
        actions: [
          Consumer<ThemeController>(
            builder: (context, themeController, _) {
              IconData icon;
              switch (themeController.themeMode) {
                case ThemeMode.light:
                  icon = Icons.wb_sunny;
                  break;
                case ThemeMode.dark:
                  icon = Icons.nightlight_round;
                  break;
                // case ThemeMode.system:
                default:
                  icon = Icons.phone_android_outlined;
                  break;
              }

              return IconButton(
                icon: Icon(icon),
                tooltip: 'Mode',
                onPressed: () {
                  ThemeMode nextMode;
                  switch (themeController.themeMode) {
                    case ThemeMode.light:
                      nextMode = ThemeMode.dark;
                      break;
                    case ThemeMode.dark:
                      nextMode = ThemeMode.system;
                      break;
                    // case ThemeMode.system:
                    default:
                      nextMode = ThemeMode.light;
                      break;
                  }

                  themeController.setThemeMode(nextMode);
                },
              );
            },
          ),
        ],
      ),

      body: FutureBuilder(
        future: handler.retrieveStudents(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Students>> snapshot,
        ) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                final student = snapshot.data![index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      '${student.firstName} ${student.lastName}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Rok ${student.studentsYear}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudentPage()),
          );

          if (result == true) {
            setState(() {});
          }
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),

    );
  }
}
