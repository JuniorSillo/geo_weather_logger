import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_log_provider.dart';
import '../widgets/weather_log_card.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherLogProvider>(
      builder: (context, provider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final message = provider.errorMessage;
          if (message != null && context.mounted) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(message)));
            provider.clearError();
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('Weather Dashboard'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
              IconButton(
                onPressed: _logOut,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: provider.isLoading && provider.logs.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : provider.logs.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No weather logs yet. Allow location permission on your device settings to fetch the current weather.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.logs.length,
                      itemBuilder: (context, index) {
                        return WeatherLogCard(log: provider.logs[index]);
                      },
                    ),
          floatingActionButton: FloatingActionButton.large(
            onPressed: provider.isLoading
                ? null
                : () => provider.addCurrentWeatherLog(),
            child: provider.isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.add_location_alt_rounded),
          ),
        );
      },
    );
  }
}
