import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/bank_state.dart';
import '../widgets/common.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _acc = TextEditingController();
  final _amount = TextEditingController();
  String _category = 'Personal';

  @override
  void dispose() {
    _name.dispose();
    _acc.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    final amt = double.parse(_amount.text.trim());
    final to = _name.text.trim();
    final err = context.read<BankState>().transfer(to, amt, _category);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    await showSuccess(context, 'Transferred ${money(amt)} to $to');
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<BankState>().balance;
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer Money')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(child: Text('Available balance: ${money(balance)}')),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                        labelText: 'Recipient name', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Recipient name is required';
                      if (!RegExp(r'^[A-Za-z ]+$').hasMatch(v.trim())) return 'Letters only';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _acc,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Account number', prefixIcon: Icon(Icons.numbers)),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Account number is required';
                      if (!RegExp(r'^\d{10,12}$').hasMatch(v.trim())) {
                        return 'Enter 10 to 12 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Amount (₹)', prefixIcon: Icon(Icons.currency_rupee)),
                    validator: (v) => amountValidator(v, max: balance),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                        labelText: 'Category', prefixIcon: Icon(Icons.category_outlined)),
                    items: const ['Personal', 'Bills', 'Shopping', 'Food', 'Other']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send),
                    label: const Text('Send Money'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
