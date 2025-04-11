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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły studenta'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 64),
                    const SizedBox(height: 24),

                    // Imię
                    Row(
                      children: [
                        Text(
                          "Imię: ",
                          style: textTheme.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            student.firstName,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Nazwisko
                    Row(
                      children: [
                        Text(
                          "Nazwisko: ",
                          style: textTheme.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            student.lastName,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Rok studiów
                    Row(
                      children: [
                        Text(
                          "Rok studiów: ",
                          style: textTheme.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          student.studentsYear.toString(),
                          style: textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Usuń"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () async {
                    await db.deleteStudent(student.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Student został usunięty"),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    await Future.delayed(const Duration(milliseconds: 400));
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
