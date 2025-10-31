import 'package:final_project_pantrypal/screen/home_screen.dart';
import 'package:flutter/material.dart';

// --- Authentication Screen (Manages Login and Signup State) ---
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // State to switch between login (true) and signup (false)
  bool _isLogin = true;
  // State for loading indicator
  bool _isLoading = false;

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Mock authentication logic with navigation
  void _submitAuthForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String action = _isLogin ? 'Login' : 'Sign Up';
      String email = _emailController.text;

      // Show loading state
      setState(() {
        _isLoading = true;
      });

      // Mock network delay for authentication (2 seconds)
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return; // Check if the widget is still active

        // Hide loading state
        setState(() {
          _isLoading = false;
        });

        // Mock success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$action successful for user: $email'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to HomeScreen and replace the AuthScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        );

        // Clear fields after submission
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the title and button text based on the current state
    final String titleText = _isLogin ? 'Welcome Back!' : 'Create Account';
    final String buttonText = _isLogin ? 'Log In' : 'Sign Up';
    final String switchText = _isLogin
        ? 'Don\'t have an account? Sign Up'
        : 'Already have an account? Log In';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Craft'),
        // Uses the theme color defined in main.dart
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Title
              Text(
                titleText,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Authentication Form
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field (Only shown during Sign Up)
                    if (!_isLogin)
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_reset),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password.';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),

                    if (!_isLogin) const SizedBox(height: 30),


                    // Submit Button
                    ElevatedButton(
                      // Disable button when loading
                      onPressed: _isLoading ? null : _submitAuthForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                      )
                          : Text(buttonText),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Switch Button (Log In <-> Sign Up)
              TextButton(
                // Disable button when loading
                onPressed: _isLoading ? null : () {
                  setState(() {
                    _isLogin = !_isLogin; // Toggle the state
                    // Clear fields when switching
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    _formKey.currentState?.reset(); // Clear validation messages
                  });
                },
                child: Text(
                  switchText,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
