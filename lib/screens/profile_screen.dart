import 'package:clothingapp/models/user.dart';
import 'package:clothingapp/screens/AjouterVetement.dart';
import 'package:clothingapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  UserModel user = UserModel(
    login: '',
    password: '',
  );
  bool _isLoading = true;

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

  String formatBirthday(DateTime? date) {
    if (date == null) return '';
    return _dateFormatter.format(date);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('V4CV2nLdcLCmYJNn20zG')
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        DateTime? birthDate;
        if (data['birthday'] != null) {
          if (data['birthday'] is Timestamp) {
            birthDate = (data['birthday'] as Timestamp).toDate();
          } else if (data['birthday'] is String) {
            try {
              birthDate = DateFormat('dd/MM/yyyy').parse(data['birthday']);
            } catch (e) {
              print('Error parsing date: $e');
            }
          }
        }

        setState(() {
          user = UserModel(
            login: data['login'] ?? '',
            password: data['password'] ?? '',
            address: data['adresse'] ?? '',
            postalCode: data['postalCode'] ?? '',
            city: data['city'] ?? '',
            birthday: birthDate,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final Map<String, dynamic> updateData = {
          'login': user.login,
          'password': user.password,
          'birthday': Timestamp.fromDate(user.birthday!),
          'adresse': user.address,
          'postalCode': user.postalCode,
          'city': user.city,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc('V4CV2nLdcLCmYJNn20zG')
            .update(updateData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    }
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToAddClothing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AjouterVetement()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF8B4513), width: 2),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEFDCCC), // Fond beige pour toute la page
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFDCCC),
        elevation: 0,
          title: const Text(
          'Profile',
          style: TextStyle(color: Color(0xFF8B4513)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Color(0xFF8B4513)),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddClothing,
        backgroundColor: const Color(0xFF8B4513),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: user.login,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'login',
                          labelStyle:
                              const TextStyle(color: Color(0xFF8B4513)),
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: user.password,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              const TextStyle(color: Color(0xFF8B4513)),
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                        onChanged: (value) => user.password = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: formatBirthday(user.birthday),
                        decoration: InputDecoration(
                          labelText: 'Anniversaire',
                          labelStyle:
                              const TextStyle(color: Color(0xFF8B4513)),
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                        onChanged: (value) => user.birthday =
                            DateFormat('dd/MM/yyyy').parse(value),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: user.address,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle:
                              const TextStyle(color: Color(0xFF8B4513)),
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                        onChanged: (value) => user.address = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: user.postalCode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Code postal',
                          labelStyle:
                              const TextStyle(color: Color(0xFF8B4513)),
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                        onChanged: (value) => user.postalCode = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: user.city,
                        decoration: InputDecoration(
                          labelText: 'Ville',
                          labelStyle:
                              const TextStyle(color: Color(0xFF8B4513)),
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                        onChanged: (value) => user.city = value,
                      ),
                      const SizedBox(height: 20),
                       Center(
                        child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B4513),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Valider'),
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
