import 'package:flutter/cupertino.dart';

class Transaction {
  final String trxID;
  final String itemName;
  final double price;
  final DateTime date;
  Transaction(
      {@required this.date,
      @required this.itemName,
      @required this.price,
      @required this.trxID});
}
