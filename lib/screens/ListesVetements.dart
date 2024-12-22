import 'dart:convert';
import 'package:clothingapp/base64_image.dart';
import 'package:clothingapp/models/clothing.dart';
import 'package:clothingapp/screens/DetailsVetement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListesVetements extends StatefulWidget {
  const ListesVetements({super.key});

  @override
  State<ListesVetements> createState() => _ListesVetementsState();
}

class _ListesVetementsState extends State<ListesVetements> {
  double _minPrice = 0;
  double _maxPrice = 1000;
  String? _selectedCategory;
  String? _selectedSize;
  String? _selectedBrand;
  String _searchQuery = '';
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Liste des Vétements',
            style: TextStyle(
              color: Color(0xFF8B4513),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.brown),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (_showFilters) _buildFilters(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _buildFilteredStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final clothing = Clothing.fromMap(doc.data() as Map<String, dynamic>);
                    
                    bool matchesPrice = clothing.price >= _minPrice && clothing.price <= _maxPrice;
                    bool matchesCategory = _selectedCategory == null || clothing.category == _selectedCategory;
                    bool matchesSize = _selectedSize == null || clothing.size == _selectedSize;
                    bool matchesBrand = _selectedBrand == null || clothing.brand == _selectedBrand;
                    bool matchesSearch = _searchQuery.isEmpty || 
                        clothing.title.toLowerCase().contains(_searchQuery.toLowerCase());

                    return matchesPrice && matchesCategory && matchesSize && 
                           matchesBrand && matchesSearch;
                  }).toList();

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final clothing = Clothing.fromMap(doc.data() as Map<String, dynamic>);

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 4,
                        color: Colors.white.withOpacity(0.8),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsVetement(clothing: clothing),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: Base64Image(
                                    base64String: clothing.imageUrl,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.brown.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                clothing.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${clothing.price.toStringAsFixed(2)}€',
                                                style: const TextStyle(
                                                  color: Colors.brown,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.brown.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            clothing.size,
                                            style: const TextStyle(
                                              color: Colors.brown,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: Colors.brown.withOpacity(0.3),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Rechercher...',
              prefixIcon: Icon(Icons.search, color: Colors.brown),
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Prix: ${_minPrice.toStringAsFixed(0)}€ - ${_maxPrice.toStringAsFixed(0)}€',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 1000,
            divisions: 100,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.5),
            labels: RangeLabels(
              _minPrice.toStringAsFixed(0) + '€',
              _maxPrice.toStringAsFixed(0) + '€',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    hint: const Text('Catégorie'),
                    value: _selectedCategory,
                    isExpanded: true,
                    items: ['pants', 't-shirt', 'robes', 'chemise','shorts']
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    hint: const Text('Taille'),
                    value: _selectedSize,
                    isExpanded: true,
                    items: ['XS', 'S', 'M', 'L', 'XL']
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSize = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              hint: const Text('Marque'),
              value: _selectedBrand,
              isExpanded: true,
              items: ['Massimo', 'Bershka', 'Zara', 'Shein']
                  .map((brand) => DropdownMenuItem(
                        value: brand,
                        child: Text(brand),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBrand = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _minPrice = 0;
                _maxPrice = 1000;
                _selectedCategory = null;
                _selectedSize = null;
                _selectedBrand = null;
                _searchQuery = '';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Réinitialiser les filtres',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _buildFilteredStream() {
    Query query = FirebaseFirestore.instance.collection('clothes');
    return query.snapshots();
  }
}