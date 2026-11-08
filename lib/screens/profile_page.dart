import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/bank_state.dart';
import '../widgets/common.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<BankState>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                child: Text(s.userName[0], style: const TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 12),
              Text(s.userName, style: Theme.of(context).textTheme.headlineSmall),
              Text(s.email),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: const Text('Account Number'),
                      subtitle: Text(s.accountNo),
                    ),
                    const ListTile(
                      leading: Icon(Icons.savings_outlined),
                      title: Text('Account Type'),
                      subtitle: Text('Savings Account'),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Dark Mode'),
                      value: s.themeMode == ThemeMode.dark,
                      onChanged: s.toggleTheme,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () =>
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
