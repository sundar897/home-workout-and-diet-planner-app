import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // --- Helper method for email/password login ---
  void _handleEmailLogin(AuthService auth) async {
    setState(() => loading = true);
    final ok = await auth.login(emailC.text.trim(), passC.text);
    setState(() => loading = false);

    if (ok) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  // No social login methods needed

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      // Removed AppBar to match the screenshot
      body: SafeArea(
        child: SingleChildScrollView( // Added for small screen sizes
          child: Padding(
            padding: const EdgeInsets.all(24), // Increased padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons stretch
              children: [
                const SizedBox(height: 20),

                // ⚠️ This is the asset error from your screenshot
                // Make sure 'assets/icons/app_icon.png' exists
                // and is added to your 'pubspec.yaml' file.
                Image.asset(
                  'assets/icons/app_icon.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    // Show a placeholder if the image fails to load
                    return const Icon(Icons.fitness_center, size: 80, color: Colors.grey);
                  },
                ),
                const SizedBox(height: 20),

                // --- Titles from screenshot ---
                const Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Log in to continue to Workout & Diet Planner',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // --- Form Fields ---
                CustomTextField(controller: emailC, label: 'Email'),
                const SizedBox(height: 12),
                CustomTextField(controller: passC, label: 'Password', obscure: true),
                const SizedBox(height: 20),

                // --- Loading Indicator / Login Button ---
                if (loading)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    label: 'Login',
                    onPressed: () => _handleEmailLogin(auth),
                  ),
                const SizedBox(height: 12),

                // --- Create Account / Forgot Password ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text('Create account'),
                    ),
                    TextButton(
                      onPressed: () {
                        
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // End of form
              ],
            ),
          ),
        ),
      ),
    );
  }
}