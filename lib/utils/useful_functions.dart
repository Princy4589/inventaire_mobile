import 'package:get/get.dart';
import 'package:pgi_mobile/screens/SignIn/signin.dart';
import 'package:pgi_mobile/screens/Menu/menu.dart';
import 'package:pgi_mobile/services/online/scan_services.dart';
import 'package:pgi_mobile/services/online/signin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void selectedItem(item) {
  switch (item) {
    case 0:
      Get.to(() => const Menu());
      break;
    case 1:
      onLogout();
      Get.to(() => const SignIn());
      break;
  }
}

saveFormSubmit(Map<String, dynamic> formsubmit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> forms = {};
  prefs.setString('Directions', formsubmit['Managements']);
  prefs.setString('HQ', formsubmit['HQ']);
  prefs.setString('Service', formsubmit['Service']);
  forms['Managements'] = prefs.getString('Directions');
  forms["HQ"] = prefs.getString("HQ");
  forms["Service"] = prefs.getString("Service");
  return forms;
}

saveFormSubmitStock(Map<String, dynamic> formsubmit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> forms = {};

  prefs.setString('Directions', formsubmit['Managements']);
  prefs.setString('HQ', formsubmit['HQ']);
  prefs.setString('Storage', formsubmit['Storage']);
  forms['Managements'] = prefs.getString('Directions');
  forms["HQ"] = prefs.getString("HQ");
  forms["Storage"] = prefs.getString("Storage");
  return forms;
}

void saveState(state) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("State", state);
}

void saveImmo(immo) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("code_immo", immo);
}

void saveImmoID(codeimmoid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("code_immo_id", codeimmoid);
}

void saveCodeImmo(immo, state) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final immoid = await getImmoId(immo);

  prefs.setInt("code_immo_id", immoid['code_immo_id']);
  prefs.setString("state", state);
}

void saveStockScan(Map<dynamic, dynamic> formsubmit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('Directions', formsubmit['Managements']);
  prefs.setString('HQ', formsubmit['HQ']);
  prefs.setString('Storage', formsubmit['Storage']);
}
