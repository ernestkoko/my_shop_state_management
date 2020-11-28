import 'package:flutter/material.dart';
import 'package:meter_reading_app/helpers/sqlite_db_helper.dart';

import '../model/form.dart';

/// provider with a mixin for letting listeners know something changes
class FormsProvider with ChangeNotifier {
  //declare a list of empty forms
  List<FeedbackForm> _forms = [];

  //getter for the list of forms
  List<FeedbackForm> get forms {
    return [..._forms];
  }

  void addReading(
      {String par,
      String account,
      String customerMobile,
      String comment,
      String marketerName}) {
    //get an object of a feedback form
    final form = FeedbackForm(
      id: DateTime.now().toString(),
      account: account,
      par: par,
      comment: comment,
      mobile: customerMobile,
      marketer: marketerName,
    );

    //add the form to the list
    _forms.add(form);
    //notify listeners
    notifyListeners();

    //insert the data into the db, specify the name of the table
    DBHelper.insert('meter_reading', {
      'id': form.id,
      'account_number': form.account,
      'par': form.par,
      'comment': form.comment,
      'customer_mobile': form.mobile,
      'marketer_name': form.marketer,
    });
  }

  //fetch the data from the db
  Future<void> fetchDataFromDB() async {
    //get the list of data
    final formsList = await DBHelper.getFromDb('meter_reading');
    _forms = formsList
        .map((form) => FeedbackForm(
              id: form['id'],
              account: form['account_number'],
              par: form['par'],
              comment: form['comment'],
              mobile: form['customer_mobile'],
              marketer: form['marketer_name'],
            ))
        .toList();
    //notify listeners
    notifyListeners();
  }

  //delete a row from the table
  Future<void> deleteRow(String id, Future<void> Function(int) callback) async {
    print("Delete Called");
   await DBHelper.deleteFromDB(
      'meter_reading',
      id,
    ).then((response)async {
      await callback(response);
    });
    notifyListeners();
  }
}
