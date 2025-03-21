import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  File? _selectedImage;
  String? _uploadedProfileUrl;

  final ImagePicker _picker = ImagePicker();
  //final int _userId = DateTime.now().millisecondsSinceEpoch % 1000000; // Autogenerated ID

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
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
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
                  final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
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

  Future<String?> _uploadImage(String userId) async {
    if (_selectedImage == null) return null;

    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'user_profiles/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = await storageRef.putFile(_selectedImage!);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _uploadedProfileUrl = downloadUrl;
      });

      print("✅ Upload successful: $_uploadedProfileUrl");
      return downloadUrl;
    } catch (e) {
      print("❌ Upload failed: $e");
      return null;
    }
  }

  // Function to save user data to SharedPreferences
  void _saveUserData(
      String userName, String email, String? profilePicUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('emailOrphone', email);
    await prefs.setString('userType', "Customer");

    if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
      await prefs.setString('profilePicPath', profilePicUrl);
      print('Profile Pic URL saved successfully: $profilePicUrl');
    } else {
      print('No profile picture URL to save.');
    }
  }

  // Sign-Up Function
  Future<int> _getNextUserId() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      int lastUserId = snapshot.docs.first['id'];
      return lastUserId + 1;
    } else {
      return 1; // Start from 1 if no users exist
    }
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final inputText = _emailOrPhoneController.text.trim();
        final contactNumber = _contactNumberController.text.trim();

        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(inputText) &&
            !RegExp(r'^[0-9]{10}$').hasMatch(inputText)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Enter a valid email or phone number.')),
          );
          return;
        }

        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: inputText,
          password: _passwordController.text.trim(),
        );

        final User? user = userCredential.user;

        if (user != null) {
          final userId = user.uid;

          // Get next sequential user ID
          int newUserId = await _getNextUserId();

          String? _profilePicUrl = await _uploadImage(userId);
          await user.sendEmailVerification();

          await FirebaseFirestore.instance.collection('users').doc(userId).set({
            'id': newUserId,
            'username': _usernameController.text.trim(),
            'name': _nameController.text.trim(),
            'emailOrPhone': inputText,
            'contact_number': contactNumber,
            '_profilePicUrl': _profilePicUrl ?? "",
            'isVerified': false,
            'user_type': "Customer",
            'signup_date': Timestamp.now(),
          });

          _saveUserData(
              _usernameController.text.trim(), inputText, _profilePicUrl);

          // Create a new entry in the "customers" collection
          int newCustomerId =
              await _getNextCustomerId(); // Function to get next customer_id

          await FirebaseFirestore.instance
              .collection('customer')
              .doc(newCustomerId.toString())
              .set({
            'customer_id': newCustomerId,
            'customer_name': _usernameController.text.trim(),
            'customer_contact': contactNumber,
            'customer_email': inputText,
            'customer_image_url': _profilePicUrl ?? "",
            'van_id': 0,
            'route_id': 0,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Sign-Up Successful! Verify your email before logging in.')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password must be at least 6 characters long.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email format.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

// Function to generate the next `customer_id` sequentially
  Future<int> _getNextCustomerId() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('customer')
        .orderBy('customer_id', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      int lastCustomerId = snapshot.docs.first['customer_id'];
      return lastCustomerId + 1;
    } else {
      return 1; // Start from 1 if no customers exist
    }
  }

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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 17, 15),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(
                            _selectedImage!) // Show selected image before upload
                        : (_uploadedProfileUrl != null &&
                                _uploadedProfileUrl!.isNotEmpty
                            ? NetworkImage(
                                _uploadedProfileUrl!) // Show uploaded image from Firebase
                            : null),
                    child: _selectedImage == null &&
                            (_uploadedProfileUrl == null ||
                                _uploadedProfileUrl!.isEmpty)
                        ? const Icon(Icons.person,
                            size: 90, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 18.0),
                _buildTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18.0),
                _buildTextField(
                  controller: _usernameController,
                  labelText: 'User Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18.0),
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
                const SizedBox(height: 18.0),
                _buildTextField(
                    controller: _contactNumberController,
                    labelText: 'Contact Number',
                    icon: Icons.phone),
                const SizedBox(height: 18.0),
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
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 18.0),
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
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
