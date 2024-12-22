# 🛍️ Mon Application de Vêtements "CoutureLine"

Bienvenue dans mon application **CoutureLine**, une application Flutter développée dans le cadre de mon cours de Flutter de mon M2 en IA appliqué . Cette application permet aux utilisateurs de parcourir une sélection de vêtements, d'ajouter des articles à leur panier et de gérer leurs profils.

---

## 📋 Introduction

L'objectif principal de cette application est de fournir une **MVP** (Minimum Viable Product) qui offre les fonctionnalités essentielles pour une expérience utilisateur fluide. L'application adopte les méthodologies **Agiles** avec des **User Stories** détaillant les besoins utilisateurs.

---
## 🧠 Intelligence Artificielle dans l'Application

J'ai développé un modèle d'intelligence artificielle pour classifier les vêtements automatiquement :

1. **Création du Dataset** :  
   - J'ai construit un dataset personnalisé en collectant et annotant les images de vêtements.
   - Les catégories incluent : T-shirts, pantalons, chemises, robes, shorts.

2. **Développement du Modèle** :  
   - J'ai entraîné un modèle de classification de vêtements nommé **`classifier_clothes.tflite`**.
   - Technologies utilisées :
     - **TensorFlow** pour l'entraînement.
     - **TensorFlow Lite** pour exporter et optimiser le modèle pour les appareils mobiles.

3. **Intégration dans l'Application** :  
   - Le modèle **`classifier_clothes.tflite`** est utilisé pour détecter et classifier les vêtements ajoutés par l'utilisateur lors de la soumission d'une nouvelle entrée.


---

## 🖥️ Interfaces à Développer

Notre application comporte six interfaces principales basées sur les User Stories suivantes :

### 1️⃣ [MVP] Interface de Login
- Permet aux utilisateurs de se connecter.
- Vérifie l'accès via une base de données (Firebase).
- Gère les erreurs de connexion(utilisateur inexistant ou champs vides).

### 2️⃣ [MVP] Liste des Vêtements
- Affiche une liste de vêtements disponibles avec :
  - Une image.
  - Un titre.
  - La taille.
  - Le prix.
- Navigation vers les détails d'un vêtement.

### 3️⃣ [MVP] Détail d'un Vêtement
- Présente les informations détaillées d'un vêtement :
  - Image.
  - Catégorie(détectée automatiquement grâce au modèle **`classifier_clothes.tflite`**).
  - Taille.
  - Marque.
  - Prix.
- Ajout possible au panier.

### 4️⃣ [MVP] Le Panier
- Liste les articles ajoutés au panieravec :
  - Image.
  - Titre.
  - Taille.
  - Prix.
- Permet de supprimer des articles.
- Affiche le total général.

### 5️⃣ [MVP] Profil Utilisateur
- Permet de consulter et modifier les informations personnelles :
  - Login (readonly).
  - Password (offusqué).
  - Adresse et ville.
  - Anniversaire,
  - Code postal.
- Option pour valider les modifications
- Option pour se déconnecter.


### 6️⃣ [MVP] Ajouter un Nouveau Vêtement
- Un formulaire permet d’ajouter un vêtement avec :
  - Une image.
  - Un titre.
  - Une catégorie (automatiquement détectéegrâce au modèle **`classifier_clothes.tflite`**.).
  - Une taille.
  - Une marque.
  - Un prix.

---

## 🛠️ Technologies Utilisées

- **Flutter**: Développement multiplateforme.
- **Firebase**: Base de données en temps réel pour les utilisateurs et les vêtements.
- **TensorFlow Lite**: Modèle optimisé pour la classification des vêtements.
- **Dart**: Langage principal pour Flutter.
- **Agile Methodology**: Utilisée pour la gestion des User Stories.

---

## 🌟 Fonctionnalités Réalisées

- ✔️ Interface utilisateur intuitive avec une navigation fluide.
- ✔️ Gestion des données utilisateur via Firebase.
- ✔️ Ajout et gestion des articles dans le panier.
- ✔️ Classification automatique des vêtements via le modèle IA.
- ✔️ Personnalisation du profil utilisateur.

---

## 👥 Accès Démo

Voici mon compte d'utilisateurs test pour accéder à l'application :

1. **Utilisateur **  
   - Login: `oumaima@gmail.com`  
   - Password: `123456`

---
`
## 🔧 Installation

Pour cloner ce projet sur votre machine locale, suivez les étapes ci-dessous :

 **Clonez le dépôt** en utilisant la commande suivante dans votre terminal :
   ```bash
   git clone https://github.com/Oumidark/ClothingApp.git

Par défaut, Git clone uniquement la branche par défaut (la branche main pour mon repos ). Pour accéder aux autres branches, vous devez les récupérer :
 **git branch -r**                       Pour lister toutes les branches disponibles (dans ce repos on a la branche main et la branche version-amélioré) Pour basculer a une branche spécifique faite soit :
 **git checkout main**                   Pour la branche main
 **git checkout version_amélioré**      Pour la branche version_améliorée

Sinon pour cloner une branche spécifique du projet directement, utilisez la commande suivante :

Pour cloner la branche main (version de base) :
       git clone -b main --single-branch https://github.com/Oumidark/ClothingApp.git

Pour cloner la branche version_amélioré (avec les améliorations) :
       git clone -b version_amélioré --single-branch https://github.com/Oumidark/ClothingApp.git






