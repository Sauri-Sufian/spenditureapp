import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import './Transaction_item.dart';

class ItemList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;
  ItemList({this.transaction, this.deleteTx});
  Widget build(BuildContext context) {
    print('build transactionlist');
    return Container(
      alignment: Alignment.center,
      //height: MediaQuery.of(context).size.height * 0.6,
      child: transaction.isEmpty
          ? LayoutBuilder(builder: (context, constrains) {
              return Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "No Transactions",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constrains.maxHeight * .6,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (context, index) {
                return Transaction_item(
                    transaction: transaction[index], deleteTx: deleteTx);
              },
              itemCount: transaction.length,
            ),
    );
  }
}
