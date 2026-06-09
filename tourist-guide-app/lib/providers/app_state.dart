import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/destination.dart';
import '../data/dummy_data.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _hasSeenOnboarding = false;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  bool get isInitialized => _isInitialized;

  // Safe access to FirebaseAuth
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      return null;
    }
  }

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    
    final auth = _auth;
    if (auth != null) {
      auth.authStateChanges().listen((User? user) {
        _user = user;
        _isInitialized = true;
        notifyListeners();
      });
    } else {
      // If Firebase failed, we are initialized in "fallback mode"
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  Future<String?> signUp(String email, String password, String name) async {
    final auth = _auth;
    if (auth == null) return "Firebase not initialized. Cannot sign up.";
    
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login(String email, String password) async {
    final auth = _auth;
    if (auth == null) return "Firebase not initialized. Cannot login.";

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await _auth?.signOut();
    } catch (e) {
      debugPrint("Logout failed: $e");
    }
  }
}

class BookmarkProvider with ChangeNotifier {
  List<String> _favoriteIds = [];
  String? _userId;

  List<String> get favoriteIds => _favoriteIds;

  void updateUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      if (_userId != null) {
        _loadFavorites();
      } else {
        _favoriteIds = [];
        notifyListeners();
      }
    }
  }

  Future<void> _loadFavorites() async {
    if (_userId == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_userId!).collection('favorites').get();
      _favoriteIds = doc.docs.map((d) => d.id).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
  }

  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  Future<void> toggleFavorite(String id) async {
    if (_userId == null) return;

    try {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
        await FirebaseFirestore.instance.collection('users').doc(_userId!).collection('favorites').doc(id).delete();
      } else {
        _favoriteIds.add(id);
        await FirebaseFirestore.instance.collection('users').doc(_userId!).collection('favorites').doc(id).set({
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    }
  }
}

class DestinationProvider with ChangeNotifier {
  List<Destination> _destinations = [];
  bool _isLoading = false;

  List<Destination> get destinations => _destinations;
  bool get isLoading => _isLoading;

  DestinationProvider() {
    fetchDestinations();
  }

  Future<void> fetchDestinations() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try to check if Firebase is initialized before accessing Firestore
      Firebase.app(); 
      final snapshot = await FirebaseFirestore.instance.collection('destinations').get();
      if (snapshot.docs.isNotEmpty) {
        _destinations = snapshot.docs.map((doc) => Destination.fromFirestore(doc)).toList();
      } else {
        _destinations = dummyDestinations;
      }
    } catch (e) {
      debugPrint("Using Fallback: Firebase not ready or empty. Error: $e");
      _destinations = dummyDestinations;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
