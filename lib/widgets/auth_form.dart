import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isSignUp;
  final Function(String email, String password, String? username, String? phone) onSubmit;

  const AuthForm({super.key, required this.isSignUp, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isSignUp)
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        const SizedBox(height: 16),
        if (widget.isSignUp)
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: () {
            widget.onSubmit(
              _emailController.text.trim(),
              _passController.text.trim(),
              widget.isSignUp ? _usernameController.text.trim() : null,
              widget.isSignUp ? _phoneController.text.trim() : null,
            );
          },
          child: Text(widget.isSignUp ? 'Sign Up' : 'Login'),
        ),
      ],
    );
  }
}
