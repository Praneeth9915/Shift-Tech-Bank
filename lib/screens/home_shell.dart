import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';
import 'transactions_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _pages = [DashboardPage(), TransactionsPage(), ProfilePage()];
  static const _labels = ['Home', 'Transactions', 'Profile'];
  static const _icons = [Icons.home_outlined, Icons.receipt_long_outlined, Icons.person_outline];
  static const _selIcons = [Icons.home, Icons.receipt_long, Icons.person];

  @override
  Widget build(BuildContext context) {
    final body = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: KeyedSubtree(key: ValueKey(_index), child: _pages[_index]),
    );

    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth >= 800) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                labelType: NavigationRailLabelType.all,
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Icon(Icons.account_balance, size: 32),
                ),
                onDestinationSelected: (i) => setState(() => _index = i),
                destinations: [
                  for (int i = 0; i < 3; i++)
                    NavigationRailDestination(
                      icon: Icon(_icons[i]),
                      selectedIcon: Icon(_selIcons[i]),
                      label: Text(_labels[i]),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(title: Text(_labels[_index])),
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (int i = 0; i < 3; i++)
              NavigationDestination(
                icon: Icon(_icons[i]),
                selectedIcon: Icon(_selIcons[i]),
                label: _labels[i],
              ),
          ],
        ),
      );
    });
  }
}
