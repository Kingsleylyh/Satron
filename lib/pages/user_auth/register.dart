import 'package:flutter/material.dart';
import 'package:satron/pages/authformwidget/form_container_widget.dart';
import 'package:satron/pages/user_auth/login.dart';
import 'package:satron/service/firebase_auth_implementation/firebase_auth_services.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E1DA),
      appBar: AppBar(
        title: const Text("User Sign Up"),
        backgroundColor: const Color(0xFFE6B89C),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password（at least 6 character）",
                isPasswordField: true,
                inputType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical:  16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Register"),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text("Already have account? Login now"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_emailController.text.isEmpty  || _passwordController.text.isEmpty)  {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all field!")),
      );
      return;
    }

    if (_passwordController.text.length  < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password need at least 6 characters!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _auth.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Register successful! Login now")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}