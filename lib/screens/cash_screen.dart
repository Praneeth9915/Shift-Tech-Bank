import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/bank_state.dart';
import '../widgets/common.dart';

class CashScreen extends StatefulWidget {
  final bool deposit;
  const CashScreen({super.key, required this.deposit});
  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  final _key = GlobalKey<FormState>();
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    final amt = double.parse(_amount.text.trim());
    final bank = context.read<BankState>();
    if (widget.deposit) {
      bank.deposit(amt);
    } else {
      final err = bank.withdraw(amt);
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        return;
      }
    }
    await showSuccess(
        context, '${widget.deposit ? 'Deposited' : 'Withdrawn'} ${money(amt)} successfully');
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<BankState>().balance;
    final title = widget.deposit ? 'Deposit Money' : 'Withdraw Money';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
                  AppCard(child: Text('Current balance: ${money(balance)}')),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Amount (₹)', prefixIcon: Icon(Icons.currency_rupee)),
                    validator: (v) => amountValidator(v, max: widget.deposit ? null : balance),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(onPressed: _submit, child: Text(title)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
