
import 'package:clothingapp/screens/ListesVetements.dart';
import 'package:clothingapp/screens/Panier.dart';

import 'package:clothingapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _pages = [
    const ListesVetements(),
    const Panier(),
    const ProfileScreen(),
  ];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
     // Couleur de fond pour toute la page
      backgroundColor: const Color(0xFFEFDCCC),
      
      body: Container(
        color: const Color(0xFFEFDCCC), // S'assure que le fond est uniforme
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEFDCCC),
          border: Border(
            top: BorderSide(color: Colors.brown, width: 1), // Ligne supérieure
          ),
        ),
        child: Row(
          children: [
            _buildNavItem(
              icon: Icons.attach_money,
              label: 'Acheter',
              isSelected: _currentIndex == 0,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            _buildSeparator(),
            _buildNavItem(
              icon: Icons.shopping_cart,
              label: 'Panier',
              isSelected: _currentIndex == 1,
              onTap: () => setState(() => _currentIndex = 1),
            ),
            _buildSeparator(),
            _buildNavItem(
              icon: Icons.person,
              label: 'Profil',
              isSelected: _currentIndex == 2,
              onTap: () => setState(() => _currentIndex = 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.brown : Colors.white),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.brown : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: 2,
      color: Colors.brown,
      height: 70, // Ajustez la hauteur si nécessaire
    );
  }
}