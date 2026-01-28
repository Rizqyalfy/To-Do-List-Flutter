import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/data/datasources/auth_firebase_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthFirebaseService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSection(
            context,
            title: 'Account',
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    user?.displayName?.substring(0, 1).toUpperCase() ??
                        user?.email?.substring(0, 1).toUpperCase() ??
                        'U',
                  ),
                ),
                title: Text(user?.displayName ?? 'User'),
                subtitle: Text(user?.email ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  _showLogoutDialog(context, authService);
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Appearance',
            children: [
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                subtitle: const Text('System default'),
                onTap: () {
                  _showThemeDialog(context);
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Data',
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_outlined),
                title: const Text('Storage Mode'),
                subtitle: Text(
                  AppConstants.storageMode == 'firebase'
                      ? 'Firebase Cloud Storage - Active'
                      : AppConstants.storageMode == 'api'
                      ? 'API (Cloud) - Not configured'
                      : 'Local Storage - Active',
                ),
                trailing: const Icon(Icons.info_outline),
                onTap: () {
                  _showStorageInfoDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.backup_outlined),
                title: const Text('Backup & Restore'),
                subtitle: const Text('Export or import your data'),
                onTap: () {
                  _showComingSoonDialog(context, 'Backup & Restore');
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'About',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outlined),
                title: const Text('Version'),
                subtitle: Text(AppConstants.appVersion),
              ),
              ListTile(
                leading: const Icon(Icons.code_outlined),
                title: const Text('App Info'),
                subtitle: const Text('Built with Flutter & BLoC'),
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('System Default'),
              trailing: const Icon(Icons.check, color: Colors.blue),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () {
                _showComingSoonDialog(context, 'Manual Theme Selection');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () {
                _showComingSoonDialog(context, 'Manual Theme Selection');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStorageInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Mode: ${AppConstants.useApi ? "API (Cloud)" : "Local Storage"}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '✅ Local Storage (Currently Active):\n'
              '• Data saved on this device\n'
              '• Works offline\n'
              '• Fast performance\n'
              '• No server required\n\n'
              '⚠️ API Mode (Not configured):\n'
              '• Data saved on server\n'
              '• Sync across devices\n'
              '• Requires Laravel backend\n'
              '• Needs setup & configuration',
            ),
            const SizedBox(height: 16),
            const Text(
              'To change mode, edit app_constants.dart file.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.checklist, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('To-Do List App'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version ${AppConstants.appVersion}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            const Text('A beautiful task management app built with:'),
            const SizedBox(height: 8),
            _buildTechItem('Flutter', 'Cross-platform framework'),
            _buildTechItem('BLoC', 'State management'),
            _buildTechItem('Material Design 3', 'UI design'),
            const SizedBox(height: 16),
            const Text(
              '© 2026 - Test App To Do List',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature feature will be available in future updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    AuthFirebaseService authService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await authService.signOut();
              // Navigation handled by StreamBuilder in main.dart
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
