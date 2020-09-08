import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widget/new_transaction.dart';
import './models/transaction.dart';
import './widget/items_list.dart';
import './widget/chart.dart';

void main() {
  /* WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build home page state');
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
  bool _showChart = false;
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

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Show chart'),
        Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            })
      ],
    );
  }

  List<Widget> _buildPortraitContent(AppBar appBar, Widget txList) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        child: Chart(
          recentTransactions: _recentTranscations,
        ),
      ),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        "Budget App",
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _triggerAddNewTransaction(context),
        ),
      ],
    );
    final txList = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: ItemList(
        transaction: _userTransactions,
        deleteTx: _deleteTransaction,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) _buildLandscapeContent(),
            if (!isLandscape) ..._buildPortraitContent(appBar, txList),
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(
                        recentTransactions: _recentTranscations,
                      ),
                    )
                  : txList
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _triggerAddNewTransaction(context),
              child: Icon(Icons.add),
            ),
    );
  }
}
