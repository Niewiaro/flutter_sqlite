import 'package:flutter/material.dart';
import 'package:flutter_sqlite/sql_management/model_students.dart';
import 'package:flutter_sqlite/sql_management/database.dart';
import 'add_student.dart';

class StudentDetailsPage extends StatelessWidget {
  final Students student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final db = DataBase();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły studenta'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${student.firstName} ${student.lastName}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text("Rok studiów: ${student.studentsYear}"),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Usuń"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                  ),
                  onPressed: () async {
                    await db.deleteStudent(student.id);
                    Navigator.pop(context, true);
                  },
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edytuj"),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddStudentPage(student: student),
                      ),
                    );
                    if (result == true) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
