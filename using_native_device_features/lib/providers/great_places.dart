import 'dart:io';

import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  /// adds a place to the database
  /// [pickedTitle] is the title of the place to add
  ///  [pickedImage] is the image path to save
  void addPlace(String pickedTitle, File pickedImage) {
    //get a object of a place
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: null,
        image: pickedImage);
    //add it to the list
    _items.add(newPlace);
    //notify every listening class
    notifyListeners();

    //insert into db
    // with the specified name of the table and the Map of the data
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path
    });
  }

  /// fetches data from the database and notifies the listeners when done
  Future<void> fetchAndSetPlaces() async {
    //get the list(iterable) of data from the db with the specified name
    final dataList = await DBHelper.getData('user_places');
    // the data gotten is an iterable so we use the map function to change it to list
    _items = dataList
        .map(
          //get each item and add it to the list
          (item) => Place(
            id: item['id'],
            title: item['title'],
            location: null,
            image: File(
              item['image'],
            ),
          ),
        )
        .toList();
    //notify listeners
    notifyListeners();
  }
}
