import 'package:flutter/material.dart';
import 'package:flutter_app/model/Person.dart';
import 'package:flutter_app/repositories/PersonHttpRepository.dart';

class createPersonPage extends StatefulWidget {
  const createPersonPage({super.key});
  @override
  State<createPersonPage> createState() => _createPersonState();
}

class _createPersonState extends State<createPersonPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _personName = TextEditingController();
  final TextEditingController _personalNumber = TextEditingController();
  final PersonHttpRepository _httpRepository = PersonHttpRepository();
  bool progress = false;

  Future<Person> _submitForm() {
    int personalNumber = int.parse(_personalNumber.text);
    final person = Person.create(_personName.text, personalNumber);

    return _httpRepository.add(person);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create new person!")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _personName,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _personalNumber,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Personal Number',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Please enter your personal number'
                            : null,
              ),
              SizedBox(height: 24),
              progress
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        progress = true;
                      });
                      await Future.delayed(Duration(seconds: 1));
                      await _submitForm();
                      //Add repo to communicate with server
                      setState(() {
                        progress = false;
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Person created!')),
                        );
                      }
                    },
                    child: Text('Create!'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
