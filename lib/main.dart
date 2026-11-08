import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/cash_screen.dart';
import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'screens/transfer_screen.dart';
import 'state/bank_state.dart';
import 'theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BankState(),
      child: const BankApp(),
    ),
  );
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.select<BankState, ThemeMode>((s) => s.themeMode);
    return MaterialApp(
      title: 'Shift Tech Bank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        final Widget page;
        switch (settings.name) {
          case '/home':
            page = const HomeShell();
            break;
          case '/transfer':
            page = const TransferScreen();
            break;
          case '/deposit':
            page = const CashScreen(deposit: true);
            break;
          case '/withdraw':
            page = const CashScreen(deposit: false);
            break;
          default:
            page = const LoginScreen();
        }
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
