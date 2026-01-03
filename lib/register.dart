import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:travelbuddy/Login.dart';

const Api_url = 'http://192.168.1.1:3000'; 

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _uidController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 1. ADDED: State variable to track password visibility
  bool _isPasswordVisible = false;

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userdata = jsonEncode({
          'firebase_uid': _uidController.text,
          'full_name': _fullNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        });

        final response = await http.post(
          Uri.parse('$Api_url/api/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: userdata,
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User registered successfully')),
          );
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => Login()),
          );
        } else {
          final errorResponse = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${errorResponse['message']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // 2. GOOD PRACTICE: Always dispose controllers to save memory
    _uidController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView( // 3. ADDED: Prevents overflow when keyboard appears
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Registration Form", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 30),
              
              // ... UID Field ...
              TextFormField(
                controller: _uidController,
                decoration: const InputDecoration(
                  labelText: 'Firebase UID',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter UID' : null,
              ),
              const SizedBox(height: 20),

              // ... Full Name Field ...
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 20),

              // ... Email Field ...
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 4. UPDATED: Password Field with Toggle Icon
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter password';
                  if (value.length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('Register'),
              ),

              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Login())),
                child: const Text('Already have an account? Login', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
