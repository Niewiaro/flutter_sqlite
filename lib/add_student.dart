import 'package:flutter/material.dart';
import 'package:flutter_sqlite/sql_management/database.dart';
import 'package:flutter_sqlite/sql_management/model_students.dart';

class AddStudentPage extends StatefulWidget {
  final Students? student;

  const AddStudentPage({super.key, this.student});

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
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstName.text = widget.student!.firstName;
      _lastName.text = widget.student!.lastName;
      _year.text = widget.student!.studentsYear.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.student == null ? "Dodaj studenta" : "Edytuj studenta",
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                            value == null || value.isEmpty
                                ? "Wpisz imię"
                                : null,
                  ),
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 35),

                  // Przycisk Zapisz
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final student = Students(
                            id:
                                widget.student?.id ??
                                DateTime.now().millisecondsSinceEpoch,
                            firstName: _firstName.text.trim(),
                            lastName: _lastName.text.trim(),
                            studentsYear: int.parse(_year.text),
                          );

                          await handler.insertStudents([student]);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.student == null
                                    ? "Dodano studenta"
                                    : "Zaktualizowano studenta",
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );

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
        ),
      ),
    );
  }
}
