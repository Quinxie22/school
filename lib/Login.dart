import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import the dashboard page

const Api_url = 'http://192.168.1.1:3000'; // Replace with your actual API URL

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final loginData = jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        });

        final response = await http.post(
          Uri.parse('$Api_url/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: loginData,
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final accessToken = jsonResponse['accessToken'];
          final refreshToken = jsonResponse['refreshToken'];
          // final full_name = jsonResponse['full_name']; // Get full_name from response
          // final email = jsonResponse['email']; // Get email from response


          // Navigate to the dashboard page with tokens
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Dashboard(
                accessToken: accessToken,
                refreshToken: refreshToken,
                // userName: full_name,
                // email: email,
              ),
            ),
          );
        } else {
          final errorResponse = jsonDecode(response.body);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to login: ${errorResponse['message']}')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error occurred during login: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: loginUser,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}