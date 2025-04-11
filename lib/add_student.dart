import 'package:flutter/material.dart';
import 'package:flutter_sqlite/sql_management/database.dart';
import 'package:flutter_sqlite/sql_management/model_students.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _year = TextEditingController();

  final DataBase handler = DataBase();

  @override
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj studenta"),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nowy student", style: textTheme.headlineSmall),
              const SizedBox(height: 24),

              // Imię
              TextFormField(
                controller: _firstName,
                decoration: InputDecoration(
                  labelText: "Imię",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Wpisz imię" : null,
              ),
              const SizedBox(height: 16),

              // Nazwisko
              TextFormField(
                controller: _lastName,
                decoration: InputDecoration(
                  labelText: "Nazwisko",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Wpisz nazwisko"
                            : null,
              ),
              const SizedBox(height: 16),

              // Rok studiów
              TextFormField(
                controller: _year,
                decoration: InputDecoration(
                  labelText: "Rok studiów",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Wpisz rok";
                  final year = int.tryParse(value);
                  if (year == null || year < 1 || year > 5) {
                    return "Podaj rok od 1 do 5";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Przycisk Zapisz
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final student = Students(
                        id: DateTime.now().millisecondsSinceEpoch,
                        firstName: _firstName.text.trim(),
                        lastName: _lastName.text.trim(),
                        studentsYear: int.parse(_year.text),
                      );

                      await handler.insertStudents([student]);
                      Navigator.pop(context, true);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Zapisz"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
