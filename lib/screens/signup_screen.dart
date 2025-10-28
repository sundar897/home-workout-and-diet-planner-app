import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';


class SignupScreen extends StatefulWidget {
const SignupScreen({super.key});
@override
State<SignupScreen> createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen> {
final nameC = TextEditingController();
final emailC = TextEditingController();
final passC = TextEditingController();
bool loading = false;


@override
void dispose() {
nameC.dispose();
emailC.dispose();
passC.dispose();
super.dispose();
}


@override
Widget build(BuildContext context) {
final auth = Provider.of<AuthService>(context);
return Scaffold(
appBar: AppBar(title: const Text('Sign Up')),
body: Padding(
padding: const EdgeInsets.all(16),
child: Column(children: [
CustomTextField(controller: nameC, label: 'Full Name'),
const SizedBox(height: 12),
CustomTextField(controller: emailC, label: 'Email'),
const SizedBox(height: 12),
CustomTextField(controller: passC, label: 'Password', obscure: true),
const SizedBox(height: 20),
if (loading) const CircularProgressIndicator(),
if (!loading)
CustomButton(
label: 'Create Account',
onPressed: () async {
setState(() => loading = true);
final ok = await auth.signup(nameC.text.trim(), emailC.text.trim(), passC.text);
setState(() => loading = false);
if (ok) {
Navigator.pushReplacementNamed(context, '/home');
} else {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email already used')));
}
},
),
]),
),
);
}
}