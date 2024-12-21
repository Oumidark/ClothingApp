
import 'package:clothingapp/screens/cart_screen.dart';
import 'package:clothingapp/screens/clothing_list_screen.dart';
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
    const ClothingListScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: 1), // Ligne supérieure
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
            Icon(icon, color: isSelected ? Colors.red : Colors.grey),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.grey,
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
      color: Colors.black,
      height: 70, // Ajustez la hauteur si nécessaire
    );
  }
}