import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  // Handle Login
  void _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        final inputText = _emailPhoneController.text.trim();

        // Validate Email Format
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(inputText)) {
          setState(() {
            _emailError = 'Please enter a valid email address.';
            _isLoading = false;
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
              _emailError = 'Email not verified. A verification email has been sent. Please verify and try again.';
              _isLoading = false;
            });

            // Sign out after sending verification email
            await FirebaseAuth.instance.signOut();
            return;
          }

          final userId = user.uid;

          // Fetch user data from Firestore
          DocumentSnapshot userDoc =
              await FirebaseFirestore.instance.collection('users').doc(userId).get();

          String userName = "User"; // Default name
          String profileImageUrl = ""; // Default profile image

          if (userDoc.exists) {
            userName = userDoc['name'] ?? "User"; // Fetch username from Firestore
            profileImageUrl = userDoc['profileImageUrl'] ?? ""; // Fetch profile image URL
          }

          // Save user details to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('emailOrphone', user.email ?? '');
          await prefs.setString('name', userName);
          await prefs.setString('profilePicPath', profileImageUrl);

          // print("✅ Saved Username: $userName");
          // print("✅ Saved Profile Pic URL: $profileImageUrl");

          // Navigate to the Category Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CategoryPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
          if (e.code == 'user-not-found') {
            _emailError = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            _passwordError = 'Incorrect password.';
          } else {
            _emailError = 'An error occurred. Please try again.';
          }
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 185, 92, 15),
        elevation: 0,
        title: const Text('Login'),
        automaticallyImplyLeading: false, // Removes the back arrow
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
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
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
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
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
                  onPressed: _isLoading ? null : _login, // Disable button if loading
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 185, 92, 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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
                    style: TextStyle(color: Color.fromARGB(255, 10, 22, 2)),
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
