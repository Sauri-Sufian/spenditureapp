import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewTransaction extends StatefulWidget {
  final Function addTransaction;
  AddNewTransaction({this.addTransaction});
  @override
  _AddNewTransactionState createState() => _AddNewTransactionState();
}

class _AddNewTransactionState extends State<AddNewTransaction> {
  final _itemController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _selectedDate;
  void _onSubmission() {
    /* print(_itemController.text);
    print(_priceController.text); */
    final newItem = _itemController.text;
    final newPrice = double.parse(_priceController.text);
    if (newItem.isEmpty || newPrice <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTransaction(newItem, newPrice, _selectedDate);
    Navigator.of(context).pop();
    //widget.addTransaction()
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickData) {
      if (pickData == null) {
        return;
      }
      setState(() {
        _selectedDate = pickData;
      });
    });
    print('...');
  }

  Widget build(BuildContext context) {
    print('build newTransactions');
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Item Name',
                ),
                controller: _itemController,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                controller: _priceController,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Text(_selectedDate == null
                        ? 'No Date Choosen !'
                        : DateFormat.yMd().format(_selectedDate)),
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: _presentDatePicker)
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _onSubmission,
                child: Text(
                  'Add Transaction',
                  //style: TextStyle(color: Colors.purple),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
