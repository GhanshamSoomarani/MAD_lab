import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String username;
  final String password;
  final String email;
  final String dob;
  final String gender;

  SuccessPage({
    required this.username,
    required this.password,
    required this.email,
    required this.dob,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Success Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Username: $username"),
            Text("Email: $email"),
            Text("DOB: $dob"),
            Text("Gender: $gender"),
          ],
        ),
      ),
    );
  }
}
