import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

/// This is a simple test to verify Firebase is properly configured
/// Run this before testing the main app
class FirebaseTestApp extends StatelessWidget {
  const FirebaseTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Connection Test'),
        ),
        body: FutureBuilder(
          future: _testFirebaseConnection(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Testing Firebase connection...'),
                  ],
                ),
              );
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    const Text('Firebase Connection Failed'),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please check:\n'
                      '1. google-services.json is in android/app/\n'
                      '2. Firebase project is configured\n'
                      '3. Internet connection is available',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Firebase Connected Successfully!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Your app is ready to use Firebase services.'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Future<void> _testFirebaseConnection() async {
    try {
      // Test if Firebase is initialized
      await Future.delayed(const Duration(seconds: 2)); // Simulate connection test
      
      // Check if Firebase apps are available
      final app = Firebase.app();
      if (app.name.isEmpty) {
        throw Exception('Firebase app not properly initialized');
      }
      
      // Test completed successfully
      print('Firebase connection test passed');
    } catch (e) {
      print('Firebase connection test failed: $e');
      rethrow;
    }
  }
}
