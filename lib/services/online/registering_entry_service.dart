import 'package:shared_preferences/shared_preferences.dart';

//Sauvegarde different liste vers le cache de l'application

saveDirectionList(List<String> listDirection) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('direction', listDirection);
}

saveSeatList(List<String> listSeat) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('siege', listSeat);
}

saveBuildingList(List<String> listBuilding) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('batiment', listBuilding);
}

saveStorageList(List<String> listStorage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('stockage', listStorage);
}

saveUserInfo(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('user_id', id);
}
