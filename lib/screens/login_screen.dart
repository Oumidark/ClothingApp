import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clothingapp/screens/home_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(const LoginScreen());
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('login', isEqualTo: _loginController.text)
          .where('password', isEqualTo: _passwordController.text)
          .get();

      if (userDoc.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error logging in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color.fromARGB(255, 94, 42, 5), Color(0xFFDEB887)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'CoutureLine',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(3, 3),
                                blurRadius: 5,
                                color: Colors.brown,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: const Color(0xFF8B4513),
                              offset: const Offset(1, 0),
                              blurRadius: 0,
                            ),
                            Shadow(
                              color: const Color(0xFF8B4513),
                              offset: const Offset(-1, 0),
                              blurRadius: 0,
                            ),
                            Shadow(
                              color: const Color(0xFF8B4513),
                              offset: const Offset(0, 1),
                              blurRadius: 0,
                            ),
                            Shadow(
                              color: const Color(0xFF8B4513),
                              offset: const Offset(0, -1),
                              blurRadius: 0,
                            ),
                            Shadow(
                              color: const Color(0xFF8B4513),
                              offset: const Offset(0.7, 0.7),
                              blurRadius: 0,
                            ),
                            Shadow(
                              color: const Color(0xFF8B4513),
                              offset: const Offset(-0.7, -0.7),
                              blurRadius: 0,
                            ),
                            Shadow(
                              color: const Color(0xFF8B4513),
                              offset: const Offset(0.7, -0.7),
                              blurRadius: 0,
                            ),
                            Shadow(
                              color: const Color(0xFF8B4513),
                              offset: const Offset(-0.7, 0.7),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              'Bienvenue dans l\'univers de l\'élégance',
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          isRepeatingAnimation: false,
                          displayFullTextOnTap: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _loginController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Login',
                              labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF8B4513)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF8B4513)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF8B4513)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF8B4513)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B4513),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Se connecter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}