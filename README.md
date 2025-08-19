# 💰 Finance Tracker App

A comprehensive Flutter application for personal finance management with Firebase backend integration. Track your expenses, manage budgets, and gain insights into your spending patterns with beautiful charts and analytics.

## ✨ Features

- 🔐 **User Authentication** - Secure email/password authentication with Firebase Auth
- 💸 **Expense Tracking** - Add, edit, and categorize your transactions
- 📊 **Analytics Dashboard** - Visual charts and insights using FL Chart
- 🎯 **Budget Management** - Set and track budgets for different categories
- 📱 **Multi-platform Support** - Works on Android, iOS, Web, and Desktop
- 🖼️ **Receipt Management** - Capture and store receipt images
- 🌙 **Modern UI** - Clean and intuitive design with Google Fonts
- ☁️ **Cloud Sync** - Real-time data synchronization with Firestore
- 📈 **Financial Reports** - Detailed spending analysis and trends

## 🏗️ Architecture

```
lib/
├── screens/           # UI screens
│   ├── auth/         # Authentication screens
│   ├── home/         # Dashboard and main screens
│   ├── transactions/ # Transaction management
│   ├── analytics/    # Charts and reports
│   ├── settings/     # App settings
│   └── onboarding/   # Welcome screens
├── models/           # Data models
├── providers/        # State management (Provider)
├── services/         # Firebase and API services
├── widgets/          # Reusable UI components
└── utils/           # Helper functions and constants
```

## 🛠️ Tech Stack

- **Framework**: Flutter (SDK ^3.8.1)
- **State Management**: Provider
- **Backend**: Firebase
  - Authentication
  - Firestore Database
  - Cloud Storage
- **Charts**: FL Chart
- **UI**: Material Design with Google Fonts
- **Local Storage**: Shared Preferences
- **Image Handling**: Image Picker, Cached Network Image

## 📦 Dependencies

### Core Dependencies
- `firebase_core` - Firebase initialization
- `firebase_auth` - User authentication
- `cloud_firestore` - NoSQL database
- `firebase_storage` - File storage
- `provider` - State management
- `fl_chart` - Beautiful charts and graphs
- `google_fonts` - Typography
- `image_picker` - Camera/gallery access
- `shared_preferences` - Local data persistence
- `intl` - Internationalization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / VS Code
- Google account for Firebase

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/22adi66/finanace_tracker_app.git
   cd finanace_tracker_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Follow the detailed instructions in `FIREBASE_SETUP.md`
   - Configure Firebase for your platform (Android/iOS/Web)
   - Update `firebase_options.dart` with your configuration

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Configuration
The app uses Firebase for backend services. Make sure to:
1. Create a Firebase project
2. Enable Authentication (Email/Password)
3. Set up Firestore Database
4. Configure Firebase Storage
5. Add your platform-specific configuration files

Refer to `FIREBASE_SETUP.md` for detailed setup instructions.

### Assets
The app includes onboarding images in `assets/images/`:
- `onboarding_1.jpg`
- `onboarding_2.jpg` 
- `onboarding_3.jpg`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🛡️ Security

- All sensitive data is stored securely in Firebase
- User authentication is handled by Firebase Auth
- Firestore security rules are configured in `firestore.rules`

## 📞 Support

If you have any questions or need help, please open an issue in the repository.

---

**Note**: This README was created and maintained by GitHub Copilot to provide comprehensive documentation for the Finance Tracker App project.
