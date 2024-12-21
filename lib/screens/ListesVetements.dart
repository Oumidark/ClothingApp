import 'dart:convert';

import 'package:clothingapp/base64_image.dart';
import 'package:clothingapp/models/clothing.dart';
import 'package:clothingapp/screens/DetailsVetement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListesVetements extends StatelessWidget {
  const ListesVetements({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFDCCC), // Appliquer la couleur ici
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFDCCC), // Fond de l'AppBar
        elevation: 0, // Enlever l'ombre de l'AppBar
      
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clothes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final clothing = Clothing.fromMap(doc.data() as Map<String, dynamic>);

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsVetement(clothing: clothing),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Base64Image(
                          base64String: clothing.imageUrl,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,//alignement a gauche
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,//espace entre size et price

                              children: [
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,//aligner a gauche
                                children: [
                                  Text(
                                    clothing.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${clothing.price.toStringAsFixed(2)}€',
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            

                              Text(
                                 clothing.size,
                                  style: const TextStyle(
                                    color: Colors.brown,
                                    fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}