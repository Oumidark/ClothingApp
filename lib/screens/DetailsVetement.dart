import 'dart:convert';
import 'package:clothingapp/base64_image.dart';
import 'package:clothingapp/models/clothing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailsVetement extends StatelessWidget {
  final Clothing clothing;

  const DetailsVetement({super.key, required this.clothing});

  Future<void> _addToCart(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('cart').add({
        ...clothing.toMap(),
        'userId': 'current_user_id',
        'addedAt': FieldValue.serverTimestamp(),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajouté au panier avec succès')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;
    final appBarHeight = AppBar().preferredSize.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true, 
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            clothing.title,
            style: const TextStyle(
              color: Color(0xFF8B4513),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.5),
          iconTheme: const IconThemeData(color: Color(0xFF8B4513)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: statusBarHeight + appBarHeight),
              
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Base64Image(
                  base64String: clothing.imageUrl,
                  fit: BoxFit.contain, 
                ),
              ),
              // Container pour les détails
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clothing.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF8B4513),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${clothing.price.toStringAsFixed(2)} €',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            icon: Icons.checkroom,
                            text: 'Catégorie: ${clothing.category}',
                            iconColor: const Color(0xFF8B4513),
                          ),
                          _DetailRow(
                            icon: Icons.straighten_outlined,
                            text: 'Taille: ${clothing.size}',
                            iconColor: const Color(0xFF8B4513),
                          ),
                          _DetailRow(
                            icon: Icons.local_offer,
                            text: 'Marque: ${clothing.brand}',
                            iconColor: const Color(0xFF8B4513),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addToCart(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: const Color(0xFF8B4513),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Ajouter au panier',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const _DetailRow({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
