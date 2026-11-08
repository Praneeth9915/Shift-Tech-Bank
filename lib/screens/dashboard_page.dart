import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/bank_state.dart';
import '../widgets/common.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<BankState>();
    final wide = MediaQuery.of(context).size.width >= 900;

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome back, ${s.userName} 👋',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        BalanceCard(balance: s.balance, name: s.userName, accountNo: s.accountNo),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: StatCard(
                    label: 'Income', value: s.totalIn, icon: Icons.arrow_downward, color: Colors.green)),
            const SizedBox(width: 12),
            Expanded(
                child: StatCard(
                    label: 'Expenses', value: s.totalOut, icon: Icons.arrow_upward, color: Colors.red)),
          ],
        ),
        const SizedBox(height: 20),
        Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            QuickAction(
                icon: Icons.send, label: 'Transfer', onTap: () => Navigator.pushNamed(context, '/transfer')),
            QuickAction(
                icon: Icons.add_card, label: 'Deposit', onTap: () => Navigator.pushNamed(context, '/deposit')),
            QuickAction(
                icon: Icons.payments_outlined,
                label: 'Withdraw',
                onTap: () => Navigator.pushNamed(context, '/withdraw')),
          ],
        ),
      ],
    );

    final recent = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Transactions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final t in s.transactions.take(6)) TxTile(tx: t),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: left),
                    const SizedBox(width: 24),
                    Expanded(flex: 4, child: recent),
                  ],
                )
              : Column(children: [left, const SizedBox(height: 20), recent]),
        ),
      ),
    );
  }
}
