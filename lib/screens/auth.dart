import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crispycart/widgets/auth_form.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crispycart/screens/home.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool SignUp = false;

Future<void> _signInWithGoogle() async {
  try {
    final googleSignIn = GoogleSignIn(scopes: ['email']);
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return; // User cancelled the sign-in

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await FirebaseAuth.instance.signInWithCredential(credential);

    // Save user data to Firestore if new user
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'email': userCred.user!.email,
        'username': userCred.user!.displayName,
        'phone': userCred.user!.phoneNumber,
        'createdAt': Timestamp.now(),
      });
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const HomeScreen()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed in with Google!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
    );
  }
}



  void _submitForm(String email, String password, String? username, String? phone) async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      if (SignUp) {
        // SIGN UP
        final userCred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await firestore.collection('users').doc(userCred.user!.uid).set({
          'email': email,
          'username': username,
          'phone': phone,
          'createdAt': Timestamp.now(),
        });
        setState(() {
          SignUp = false;
        });
      } else {
        // SIGN IN
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const HomeScreen()));


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showPasswordResetDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Send'),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: emailController.text.trim(),
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reset email sent!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3FF),
      body: SafeArea(
        child:  Center(
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => SignUp = false),
                              child: Column(
                                children: [
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: SignUp ? Colors.grey : Colors.deepOrange,
                                    ),
                                  ),
                                  if (!SignUp)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      height: 2,
                                      width: 60,
                                      color: Colors.deepOrange,
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () => setState(() => SignUp = true),
                              child: Column(
                                children: [
                                  Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: SignUp ? Colors.deepOrange : Colors.grey,
                                    ),
                                  ),
                                  if (SignUp)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      height: 2,
                                      width: 60,
                                      color: Colors.deepOrange,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
              
                         AuthForm(
                            isSignUp: SignUp,
                            onSubmit: _submitForm,
                          ),
                        
                        if(!SignUp)
                        TextButton(
                          onPressed: () => _showPasswordResetDialog(context),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                        // google sign in
                        const Divider(height: 40, thickness: 1),
                        ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        minimumSize: const Size(double.infinity, 40),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                        icon: Image.asset(
                        'assets/google.png', // Add a proper Google logo in your assets
                         height: 12,
                        ),
                        label: const Text('Sign in with Google'),
                       onPressed: _signInWithGoogle,
                      ),
              
                      ],
                    ),
                  ),
              
                  // Image
                  ClipOval(
                    child: Image.asset(
                      'assets/food.jpg.jpg',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
      ),
    );
  }
}
