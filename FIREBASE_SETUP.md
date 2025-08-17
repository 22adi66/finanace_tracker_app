# 🔥 Firebase Setup Guide for Finance Tracker App

## Prerequisites
- Flutter installed and working
- Android Studio (for Android development)
- Google account for Firebase

## Step-by-Step Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Project name: `finance-tracker-app`
4. Enable Google Analytics
5. Choose Analytics location
6. Click "Create project"

### 2. Enable Authentication
1. In Firebase Console → Authentication
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password"
5. Click "Save"

### 3. Create Firestore Database
1. Firebase Console → Firestore Database
2. Click "Create database"
3. Choose "Start in test mode"
4. Select location
5. Click "Done"

### 4. Add Android App
1. Click Android icon in project overview
2. **Package name**: `com.example.finanace_tracker_app`
3. **App nickname**: `Finance Tracker`
4. Click "Register app"
5. **Download `google-services.json`**
6. **IMPORTANT**: Replace the template file `android/app/google-services.json.template` with your downloaded `google-services.json`

### 5. Get Firebase Configuration
1. In Firebase Console → Project Settings
2. Scroll down to "Your apps"
3. Click on your Android app
4. Copy the configuration values

### 6. Update firebase_options.dart
Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase config:

```dart
// Replace these values with your actual Firebase config
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',           // From Firebase config
  appId: 'YOUR_ACTUAL_APP_ID',             // From Firebase config
  messagingSenderId: 'YOUR_SENDER_ID',      // From Firebase config
  projectId: 'YOUR_ACTUAL_PROJECT_ID',      // From Firebase config
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### 7. Update Firestore Security Rules
1. In Firebase Console → Firestore Database
2. Go to "Rules" tab
3. Replace the content with the rules from `firestore.rules` file in your project

### 8. Test the Setup
Run these commands:
```bash
flutter clean
flutter pub get
flutter run
```

## Important Files Modified
- `android/build.gradle.kts` - Added Google Services plugin
- `android/app/build.gradle.kts` - Added Google Services plugin and set minSdk to 21
- `lib/main.dart` - Added Firebase initialization
- `lib/firebase_options.dart` - Firebase configuration (UPDATE THIS!)

## Troubleshooting
1. **Google Services plugin error**: Make sure you've added the actual `google-services.json` file
2. **Build errors**: Run `flutter clean` then `flutter pub get`
3. **Authentication errors**: Check if Email/Password is enabled in Firebase Console
4. **Firestore errors**: Verify security rules are set correctly

## Next Steps After Setup
1. Create test user account
2. Add sample transactions
3. Test all features
4. Deploy security rules for production

## Production Considerations
- Update Firestore security rules for production
- Add proper error handling
- Set up Firebase App Check
- Configure proper authentication flows
- Add data backup/export features
