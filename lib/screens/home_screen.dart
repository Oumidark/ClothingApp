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
    return Stack(
      children: [
        // Image de fond
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Contenu principal
        Scaffold(
          backgroundColor: Colors.transparent,
          // Wrap le body dans un Container transparent
          body: Container(
            color: Colors.transparent,
            child: _pages[_currentIndex],
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 1,
                color: Colors.brown,
              ),
              Container(
                color: const Color(0xFFEFDCCC).withOpacity(0.7),
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
            ],
          ),
        ),
      ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color.fromARGB(255, 217, 98, 13) : Colors.brown.withOpacity(0.7),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color.fromARGB(255, 217, 98, 13) : Colors.brown.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.brown.withOpacity(0.7),
    );
  }
}
