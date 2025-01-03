import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/clothing.dart';

class AjouterVetement extends StatefulWidget {
  const AjouterVetement({super.key});

  @override
  _AjouterVetementState createState() => _AjouterVetementState();
}

class _AjouterVetementState extends State<AjouterVetement> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _category;
  final _titleController = TextEditingController();
  final _sizeController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;
  Interpreter? _interpreter;
  String _classificationResult = "";

  // Liste des catégories
  final List<String> _categories = ["chemise", "pants", "robes", "shorts", "t-shirt"];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('./assets/classifier_clothes.tflite');
      setState(() {});
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _classificationResult = "Processing...";
      });
      await _classifyImage(File(image.path));
    }
  }

  Future<String> _imageToBase64() async {
    if (_imageFile == null) return '';

    try {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print('Erreur de conversion en base64: $e');
      throw Exception('Échec de la conversion de l\'image');
    }
  }

  Future<void> _classifyImage(File imageFile) async {
    if (_interpreter == null) {
      setState(() {
        _classificationResult = "Model not loaded";
      });
      return;
    }

    try {
      final img.Image? inputImage = img.decodeImage(imageFile.readAsBytesSync());
      if (inputImage == null) {
        setState(() {
          _classificationResult = "Invalid image format";
        });
        return;
      }

      final resizedImage = img.copyResize(inputImage, width: 32, height: 32);

      final input = Float32List(32 * 32 * 3);
      for (int y = 0; y < 32; y++) {
        for (int x = 0; x < 32; x++) {
          final pixel = resizedImage.getPixel(x, y);
          final index = (y * 32 + x) * 3;
          input[index] = pixel.r.toDouble();
          input[index + 1] = pixel.g.toDouble();
          input[index + 2] = pixel.b.toDouble();
        }
      }

      final output = Float32List(_categories.length).reshape([1, _categories.length]);
      _interpreter!.run(input.reshape([1, 32, 32, 3]), output);

      final predictedIndex = output[0]
          .indexWhere((score) => score == output[0].reduce((double a, double b) => a > b ? a : b));

      setState(() {
        _category = _categories[predictedIndex];
        _classificationResult = "Classified as: ${_categories[predictedIndex]}";
      });
    } catch (e) {
      setState(() {
        _classificationResult = "Error during classification: $e";
      });
    }
  }

  Future<void> _saveClothing() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageBase64 = await _imageToBase64();

      final clothing = Clothing(
        id: DateTime.now().toString(),
        title: _titleController.text,
        imageUrl: imageBase64,
        size: _sizeController.text,
        price: double.parse(_priceController.text),
        category: _category ?? '',
        brand: _brandController.text,
      );

      await FirebaseFirestore.instance
          .collection('clothes')
          .doc(clothing.id)
          .set(clothing.toMap());

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vêtement ajouté avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  } @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Ajouter un vétement', 
            style: TextStyle(color: Color(0xFF8B4513),fontWeight: FontWeight.bold,),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF8B4513)),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey),
                     color: Colors.brown.withOpacity(0.3),
                    border: Border.all(color: Colors.brown.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : const Icon(Icons.add_photo_alternate, size: 50, color: Color(0xFF8B4513)),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _classificationResult,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFF8B4513)
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(_titleController, "Titre"),
              _buildTextFormField(TextEditingController(text: _category ?? ''), "Catégorie (Classifiée)", readOnly: true),
              _buildTextFormField(_sizeController, "Taille"),
              _buildTextFormField(_brandController, "Marque"),
              TextFormField(
                controller: _priceController,
                style: const TextStyle(color: Color(0xFF8B4513)),
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  labelStyle: TextStyle(color: Color(0xFF8B4513)),
                  suffixText: '€',
                  suffixStyle: TextStyle(
                    color: Color(0xFF8B4513),
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8B4513)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8B4513)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Champ requis';
                  if (double.tryParse(value!) == null) return 'Prix invalide';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveClothing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Valider', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(TextEditingController controller, String labelText,
      {bool readOnly = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF8B4513)),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF8B4513)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8B4513)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8B4513)),
        ),
      ),
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
    );
  }
}
