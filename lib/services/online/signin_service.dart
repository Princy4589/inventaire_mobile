import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:pgi_mobile/screens/Menu/menu.dart';
import 'package:pgi_mobile/screens/SignIn/loading_screen.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/utils/base_url.dart';
import 'package:pgi_mobile/utils/token.dart';

import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = ApiUrl.baseUrl;
// une fonction qui va enregistrer les réponses du serveur par
// rapport au login

//fonction qui va enregistrer les données de l'utilisateur au cache local

//Une fonction qui va recharger le token au cas où ce dernier est expirer

// fonction qui va authentifier l'utilisateur
authService(data) async {
  Token token = Token();
  var url = Uri.parse(baseUrl + "/authenticationmobile/login");
  final response = await http.post(url, body: data);
  if (response.statusCode == 200) {
    Map<String, dynamic> listResponse = jsonDecode(response.body);
    await token.savePref(listResponse['refreshToken'], listResponse['user']);
    return true;
  } else {
    return false;
  }
}

// une fonction qui prend les token obtenues par l'utilisateur

onLogout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  for (String key in preferences.getKeys()) {
    if (key != "token") {
      preferences.remove(key);
    }
  }
}

//Charge les tab
loadTables(email, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString("user_id");
  DateTime now = DateTime.now();
  //date de connection nécessaire pour la synchronisation
  String modifiedTime =
      formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);
  prefs.setString("date_connection", modifiedTime);
  Token token = Token();
  //encrypt les valeurs email et password et l'insert dans la base de données
  final data = await token.encryptUserData(email, password);
  //instancie la classe provider
  Provider imo = Provider();
  // fetch data from server database

  //initiate the database
  final db = await imo.initDB();

  //inserting data into the local database

  await db.transaction((txn) async {
    await txn.rawInsert(''' 
      INSERT
      INTO log(id,email,password,user_id)
      VALUES (NULL,?,?,?)
    ''', [data["email"], data["password"], userId]);
  });
}

// service that will redirect to the loading screen
authenticateUser(email, password, BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  switch (connectivityResult) {
    case ConnectivityResult.bluetooth:
      return false;
    case ConnectivityResult.wifi:
      Map data = {'email': email, 'password': password};
      final userAuth = await authService(data);

      if (userAuth == true) {
        //create the local database which is offline and add the table
        //and put data inside
        await loadTables(email, password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoadingScreen()),
        );
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Erreur de connexion"),
            content: const Text("L'une des informations entrée est erronée"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('Oui'),
              ),
            ],
          ),
        );
      }
      break;
    case ConnectivityResult.ethernet:
      return false;
    case ConnectivityResult.mobile:
      return false;
    case ConnectivityResult.none:
      Token token = Token();
      final isAmatch = await token.checkUserOffline(email, password);
      if (isAmatch == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );
      }
  }
}

//une fonction qui vérifie la session de l'utilisateur si il est connecté
isLoggedIn() async {
  Token token = Token();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString("user_id");
  String? isLoggedin = await token.getToken();
  if (isLoggedin != null && isLoggedin != "" && userId != null) {
    Get.to(() => const Menu());
  }
}
