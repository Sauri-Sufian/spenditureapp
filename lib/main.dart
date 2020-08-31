import 'package:flutter/material.dart';
import './widget/new_transaction.dart';
import './models/transaction.dart';
import './widget/items_list.dart';
import './widget/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amberAccent,
        errorColor: Colors.red,
        textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
            ),
      ),
      home: BudgetApp(),
    );
  }
}

class BudgetApp extends StatefulWidget {
  @override
  _BudgetAppState createState() => _BudgetAppState();
}

class _BudgetAppState extends State<BudgetApp> {
  final List<Transaction> _userTransactions = [
    Transaction(
      trxID: "101",
      itemName: 'Clothes',
      price: 18.99,
      date: DateTime.now(),
    ),
    Transaction(
      trxID: "102",
      itemName: 'Shoes',
      price: 15.79,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTranscations {
    return _userTransactions.where(
      (tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void _addNewTransaction(
      String newTitle, double newAmount, DateTime chosenDate) {
    final newTransaction = Transaction(
      date: chosenDate,
      itemName: newTitle,
      price: newAmount,
      trxID: DateTime.now().toString(),
    );
    // print(newTransaction.itemName);
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _triggerAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddNewTransaction(
            addTransaction: _addNewTransaction,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.trxID == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Budget App",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _triggerAddNewTransaction(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Chart(
              recentTransactions: _recentTranscations,
            ),
            ItemList(
              transaction: _userTransactions,
              deleteTx: _deleteTransaction,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _triggerAddNewTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
