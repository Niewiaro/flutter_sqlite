import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
        elevation: 2,
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
