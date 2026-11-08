import 'package:flutter/material.dart';

enum TxType { credit, debit }

class Tx {
  final String title;
  final String category;
  final double amount;
  final TxType type;
  final DateTime date;
  const Tx(this.title, this.category, this.amount, this.type, this.date);
}

class BankState extends ChangeNotifier {
  String userName = 'Alex Morgan';
  String email = '';
  final String accountNo = 'XXXX XXXX 0092';
  double _balance = 24850.75;
  ThemeMode _themeMode = ThemeMode.light;

  final List<Tx> _tx = [
    Tx('Salary', 'Income', 52000, TxType.credit,
        DateTime.now().subtract(const Duration(days: 8))),
    Tx('Grocery Store', 'Shopping', 1840.50, TxType.debit,
        DateTime.now().subtract(const Duration(days: 6))),
    Tx('Electricity Bill', 'Bills', 2310, TxType.debit,
        DateTime.now().subtract(const Duration(days: 5))),
    Tx('Freelance Payment', 'Income', 7500, TxType.credit,
        DateTime.now().subtract(const Duration(days: 4))),
    Tx('Restaurant', 'Food', 960, TxType.debit,
        DateTime.now().subtract(const Duration(days: 3))),
    Tx('Online Shopping', 'Shopping', 3299, TxType.debit,
        DateTime.now().subtract(const Duration(days: 2))),
    Tx('Cashback Reward', 'Income', 250, TxType.credit,
        DateTime.now().subtract(const Duration(days: 1))),
  ];

  double get balance => _balance;
  ThemeMode get themeMode => _themeMode;
  List<Tx> get transactions => List.unmodifiable(_tx.reversed);
  double get totalIn => _tx
      .where((t) => t.type == TxType.credit)
      .fold(0.0, (a, t) => a + t.amount);
  double get totalOut => _tx
      .where((t) => t.type == TxType.debit)
      .fold(0.0, (a, t) => a + t.amount);

  void login(String mail) {
    email = mail;
    final name = mail.split('@').first;
    if (name.isNotEmpty) {
      userName = name[0].toUpperCase() + name.substring(1);
    }
    notifyListeners();
  }

  void toggleTheme(bool dark) {
    _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Returns an error message, or null on success.
  String? transfer(String to, double amount, String category) {
    if (amount > _balance) return 'Insufficient balance';
    _balance -= amount;
    _tx.add(Tx('Transfer to $to', category, amount, TxType.debit, DateTime.now()));
    notifyListeners();
    return null;
  }

  void deposit(double amount) {
    _balance += amount;
    _tx.add(Tx('Cash Deposit', 'Income', amount, TxType.credit, DateTime.now()));
    notifyListeners();
  }

  String? withdraw(double amount) {
    if (amount > _balance) return 'Insufficient balance';
    _balance -= amount;
    _tx.add(Tx('Cash Withdrawal', 'Cash', amount, TxType.debit, DateTime.now()));
    notifyListeners();
    return null;
  }
}
