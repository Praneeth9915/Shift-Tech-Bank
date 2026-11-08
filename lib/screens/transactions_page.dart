import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/bank_state.dart';
import '../widgets/common.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _filter = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final all = context.watch<BankState>().transactions;
    final list = all.where((t) {
      final okType = _filter == 'All' ||
          (_filter == 'Credit' && t.type == TxType.credit) ||
          (_filter == 'Debit' && t.type == TxType.debit);
      final okQuery = t.title.toLowerCase().contains(_query.toLowerCase());
      return okType && okQuery;
    }).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    hintText: 'Search transactions', prefixIcon: Icon(Icons.search)),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final f in ['All', 'Credit', 'Debit'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: _filter == f,
                        onSelected: (_) => setState(() => _filter = f),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('No transactions found'))
                    : ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) => TxTile(tx: list[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
