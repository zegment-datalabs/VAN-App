import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from camera, gallery, or remove the current photo
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              if (_selectedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Profile Photo'),
                  onTap: () {
                    setState(() {
                      _selectedImage = null;
                    });
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Function to upload image to Firebase Storage and get URL
  Future<String?> _uploadImage(String userId) async {
    if (_selectedImage == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profiles/$userId/${DateTime.now().toIso8601String()}');
      final uploadTask = await storageRef.putFile(_selectedImage!);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  // Sign-Up Function
  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final inputText = _emailOrPhoneController.text.trim();
        UserCredential userCredential;

        // Check for valid email format first
        if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(inputText)) {
          try {
            // Attempt to create the user using Firebase to check if the email is valid
            userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: inputText,
              password: _passwordController.text.trim(),
            );
          } on FirebaseAuthException catch (e) {
            // Handle errors such as invalid email (this will catch invalid emails in Firebase)
            String errorMessage = 'An error occurred. Please try again.';
            if (e.code == 'invalid-email') {
              errorMessage = 'Please enter a valid email address.';
            } else if (e.code == 'email-already-in-use') {
              errorMessage = 'This email is already in use.';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
            return; // Stop further execution
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid email address')),
          );
          return; // Stop further execution if the email format is invalid
        }

        final userId = userCredential.user!.uid;
        final profileImageUrl = await _uploadImage(userId);

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'name': _nameController.text.trim(),
          'emailOrPhone': inputText,
          'profileImageUrl': profileImageUrl,
        });

        // Save user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('emailPhone', inputText);
        prefs.setString('profilePicPath', profileImageUrl ?? 'default-avatar-url');
        prefs.setBool('isLoggedIn', true);

        await userCredential.user!.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-Up Successful! Please verify your email.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;

        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password is too weak.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  // Navigate to Login Page
  void _navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : const AssetImage('assets/default_profile.png') as ImageProvider,
                    child: _selectedImage == null
                        ? const Icon(Icons.person, size: 90, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  controller: _emailOrPhoneController,
                  labelText: 'Email or Phone Number',
                  icon: Icons.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
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
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: !_isConfirmPasswordVisible,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: _navigateToSignIn,
                      child: const Text('Sign In'),
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

  // Common function to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: validator,
    );
  }
}
