import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:using_native_device_features/providers/great_places.dart';
import 'package:using_native_device_features/widgets/image_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add_place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace(BuildContext context) {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      //show dialog
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Error'),
          content: Text('Title or Image is empty!'),
        ),
      );
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage);
    //navigate away
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: "Title"),
                    controller: _titleController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage)
                ],
              ),
            ),
          )),
          RaisedButton.icon(
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.add),
              label: Text('Add Place'),
              onPressed: () => _savePlace(context))
        ],
      ),
    );
  }
}
