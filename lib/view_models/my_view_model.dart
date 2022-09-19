import 'package:dio_example/data/models/top_level_data.dart';
import 'package:dio_example/data/repositories/my_repository.dart';
import 'package:flutter/cupertino.dart';

class MyViewModel extends ChangeNotifier {
  MyViewModel({required this.myRepository}) {
    fetchMyData();
  }

  final MyRepository myRepository;

  String errorText = "";
  bool isLoading = false;
  TopLevelData? topLevelData;

  fetchMyData() async {
    notify(true);
    topLevelData = await myRepository.fetchMemesData();
    if (topLevelData != null) {
      notify(false);
    } else {
      errorText = "Error";
      notify(false);
    }
  }

  notify(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
