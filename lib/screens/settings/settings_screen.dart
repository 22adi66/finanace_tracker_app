import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final user = authProvider.user;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppTheme.primaryColor,
                              backgroundImage: user?.photoURL != null
                                  ? NetworkImage(user!.photoURL!)
                                  : null,
                              child: user?.photoURL == null
                                  ? Text(
                                      user?.displayName.isNotEmpty == true
                                          ? user!.displayName[0].toUpperCase()
                                          : 'U',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.displayName ?? 'User',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user?.email ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            IconButton(
                              onPressed: () => _showEditProfileDialog(context),
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // App Settings - ONLY Dark Mode
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Dark Mode Toggle - ONLY THIS
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return ListTile(
                          leading: Icon(
                            themeProvider.isDarkMode 
                                ? Icons.dark_mode 
                                : Icons.light_mode,
                            color: AppTheme.primaryColor,
                          ),
                          title: const Text('Dark Mode'),
                          subtitle: Text(
                            themeProvider.isDarkMode ? 'Enabled' : 'Disabled',
                          ),
                          trailing: Switch(
                            value: themeProvider.isDarkMode,
                            onChanged: (value) => themeProvider.toggleTheme(),
                            activeColor: AppTheme.primaryColor,
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Privacy Section - ONLY Privacy Policy
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Privacy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ListTile(
                      leading: const Icon(
                        Icons.privacy_tip_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Privacy Policy'),
                      subtitle: const Text('Read our privacy policy'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sign Out Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return CustomButton(
                  text: 'Sign Out',
                  onPressed: () => _showSignOutDialog(context),
                  backgroundColor: AppTheme.errorColor,
                  isLoading: authProvider.isLoading,
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final nameController = TextEditingController(text: authProvider.user?.displayName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: CustomTextField(
          controller: nameController,
          label: 'Display Name',
          hintText: 'Enter your name',
          prefixIcon: Icons.person_outline,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();
                
                final success = await authProvider.updateProfile(
                  displayName: nameController.text.trim(),
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success 
                          ? 'Profile updated successfully' 
                          : authProvider.errorMessage ?? 'Failed to update profile'),
                      backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}