import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gotrek/features/auth/presentation/providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),

                // Title
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Join us and start trekking',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                SizedBox(height: 40),

                // Name TextField
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: Colors.blue.shade900),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Email TextField
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: Colors.blue.shade900),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Password TextField
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue.shade900),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await authProvider.register(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text,
                              );

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Registration successful!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage ?? 'Registration failed'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: authProvider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),

                SizedBox(height: 20),

                // Login Link
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

