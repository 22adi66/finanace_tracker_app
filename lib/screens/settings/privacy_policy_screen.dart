import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppTheme.lightSurfaceColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.secondaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.security,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your Privacy is Our Priority',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Privacy Sections
            _buildPrivacySection(
              'Data Collection & Usage',
              Icons.data_usage,
              [
                'We collect only essential information needed for app functionality',
                'Financial transaction data is stored securely in your personal account',
                'No personal data is shared with third parties for marketing purposes',
                'All data collection is transparent and with your explicit consent',
              ],
            ),

            _buildPrivacySection(
              'Firebase Security',
              Icons.cloud_done,
              [
                'Your data is securely stored using Google\'s trusted Firebase system',
                'All data transmission is encrypted using industry-standard protocols',
                'Firebase provides enterprise-grade security with 24/7 monitoring',
                'Your financial information is protected by Google\'s security infrastructure',
              ],
            ),

            _buildPrivacySection(
              'Data Protection Measures',
              Icons.shield,
              [
                'End-to-end encryption for all sensitive financial data',
                'Secure authentication using Firebase Auth with multi-factor options',
                'No local storage of sensitive information on your device',
              ],
            ),

            _buildPrivacySection(
              'Your Rights & Control',
              Icons.person_pin,
              [
                'You have full control over your financial data',
                'You can delete your account and all associated data',
              ],
            ),

            _buildPrivacySection(
              'Information We Don\'t Collect',
              Icons.block,
              [
                'We don\'t access your bank account or credit card details',
                'We don\'t track your location or personal browsing habits',
                'We don\'t sell your information to advertisers or data brokers',
                'We don\'t require unnecessary permissions on your device',
              ],
            ),

            _buildPrivacySection(
              'Transparency & Trust',
              Icons.visibility,
              [
                'Open source approach - our privacy practices are transparent',
                'Direct contact available for privacy-related questions',
                'Commitment to privacy by design in all features',
              ],
            ),

            const SizedBox(height: 24),

            // Footer
            Center(
              child: Text(
                'Finance Tracker - Committed to Your Privacy',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, IconData icon, List<String> points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...points.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
