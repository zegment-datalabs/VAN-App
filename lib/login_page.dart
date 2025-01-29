// login_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category/categorypage.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _emailError;
  String? _passwordError;

  // Handle Login Functionality
  void _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null; // Reset password error
    });

    if (_formKey.currentState!.validate()) {
      try {
        final inputText = _emailPhoneController.text.trim();

        // Validate Email Format
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(inputText)) {
          setState(() {
            _emailError = 'Please enter a valid email address.';
          });
          return;
        }

        // Firebase Authentication Sign-In
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: inputText,
          password: _passwordController.text.trim(),
        );

        final User? user = userCredential.user;

        if (user != null) {
          // Check if the email is verified
          if (!user.emailVerified) {
            await user.sendEmailVerification();
            setState(() {
              _emailError = 'Email not verified. Verification email sent. Please verify and try again.';
            });

            // Sign out after sending verification email
            await FirebaseAuth.instance.signOut();
            return;
          }

          // Save user details to SharedPreferences (including name)
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('emailPhone', user.email ?? '');
          await prefs.setString('userName', user.displayName ?? 'User');
          await prefs.setString('profilePicPath', user.photoURL ?? 'https://via.placeholder.com/150');

          // Navigate to the Category Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CategoryPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _emailError = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _passwordError = 'Incorrect password.';
          });
        } else {
          setState(() {
            _emailError = 'An error occurred. Please try again.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Email/Phone Input Field
                TextFormField(
                  controller: _emailPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Email or Phone Number',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: _emailError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                // Password Input Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: _passwordError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                // Login Button
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    // Implement forgot password functionality
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Redirect to Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
