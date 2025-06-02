import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class createPersonPage extends StatefulWidget {
  const createPersonPage({super.key});
  @override
  State<createPersonPage> createState() => _createPersonState();
}

class _createPersonState extends State<createPersonPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _personName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool progress = false;

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
                controller: _email,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
              ),
              SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return switch (state) {
                    AuthInitial() => ElevatedButton(
                      child: Text('Create!'),
                      onPressed: () async {
                        context.read<AuthBloc>().register(
                          email: _email.text,
                          name: _personName.text,
                          password: _password.text,
                        );
                      },
                    ),

                    AuthNotAuth() => ElevatedButton(
                      child: Text('Create!'),
                      onPressed: () async {
                        context.read<AuthBloc>().register(
                          email: _email.text,
                          name: _personName.text,
                          password: _password.text,
                        );
                      },
                    ),
                    AuthSuccess() => ElevatedButton(
                      child: Text('Create!'),
                      onPressed: () async {
                        context.read<AuthBloc>().register(
                          email: _email.text,
                          name: _personName.text,
                          password: _password.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Person created!')),
                        );
                      },
                    ),

                    AuthInProgress() => CircularProgressIndicator(),
                    AuthFailure(:final error) => ElevatedButton(
                      child: Text('Create!'),
                      onPressed: () async {
                        context.read<AuthBloc>().register(
                          email: _email.text,
                          name: _personName.text,
                          password: _password.text,
                        );
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(error)));
                      },
                    ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
