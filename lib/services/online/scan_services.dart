import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import "package:http/http.dart" as http;
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:pgi_mobile/utils/base_url.dart';
import 'package:pgi_mobile/utils/token.dart';

const baseUrl = ApiUrl.baseUrl;

//Envoie l'historique des inventaires de stock vers la base de données
Future<dynamic> addHistoryStock(
    codeImmoid, direction, stateid, userId, storageid, observation) async {
  //vérifie l'état de connexion
  var connectivityResult = await (Connectivity().checkConnectivity());
  switch (connectivityResult) {
    case ConnectivityResult.bluetooth:
      return null;
    case ConnectivityResult.wifi:
      Token token = Token();
      String? tokens = await token.getToken();
      DateTime now = DateTime.now();
      String modifiedTime =
          formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);

      Map data = {
        "time_of_operation": modifiedTime,
        "code_immo_id": codeImmoid,
        "direction_id": direction,
        'immoStateId': stateid,
        'user_id': userId,
        "storage_id": storageid,
        "observation": observation,
      };
      var url = Uri.parse(baseUrl + "/UserMobile/addHistoryStock");
      final response = await http.post(url,
          headers: {
            "Accept": 'application/json',
            'Content-Type': 'application/json',
            "Authorization": "$tokens"
          },
          body: jsonEncode(data));

      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> listResponse = jsonDecode(response.body);
          Provider provider = Provider();
          final db = await provider.initDB();
          List<Map<String, dynamic>> maps = [];
          await db.transaction((txns) async {
            maps = await txns.rawQuery("""
            select max(immoStateId) as immoStateId from ImmoState where code_immo_id=?
          """, [codeImmoid]);
          });
          await db.transaction((txns) async {
            await txns.rawInsert("""INSERT
         INTO History_Stock_Inventory
         (history_id, time_of_operation, code_immo_id, direction_id,immoStateId,user_id,storage_id,observation)
         VALUES (NULL,?,?,?,?,?,?,?)
         """, [
              modifiedTime,
              codeImmoid,
              direction,
              maps[0]["immoStateId"],
              userId,
              storageid,
              observation
            ]);
          });
          return listResponse;
      }
      break;
    case ConnectivityResult.ethernet:
      return null;
    case ConnectivityResult.mobile:
      return null;
    case ConnectivityResult.none:
      //offline, envoie les données vers la base de données mobile local sqlite
      Provider provider = Provider();
      //Définit la date
      DateTime now = DateTime.now();
      final db = await provider.initDB();
      String modifiedTime =
          formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);
      List<Map<String, dynamic>> maps = [];
      //Choisit l'id de l'état materiel dernièrement utilisé
      await db.transaction((txn) async {
        maps = await txn.rawQuery("""
            select max(immoStateId) as immoStateId from ImmoState where code_immo_id=?
          """, [codeImmoid]);
      });

      //ajoute les données vers la base de données locale mobile
      await db.transaction(
        (txns) async {
          await txns.rawInsert("""INSERT
         INTO History_Stock_Inventory
         (history_id, time_of_operation, code_immo_id, direction_id,immoStateId,user_id,storage_id,observation)
         VALUES (NULL,?,?,?,?,?,?,?)
         """, [
            modifiedTime,
            codeImmoid,
            direction,
            maps[0]["immoStateId"],
            userId,
            storageid,
            observation
          ]);
        },
      );

      return true;
  }
}

//envoie les états de matériels vers le serveur
Future<dynamic> addImmostate(state, immo) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  switch (connectivityResult) {
    case ConnectivityResult.bluetooth:
      return null;
    case ConnectivityResult.wifi:
      Token token = Token();
      String? tokens = await token.getToken();
      DateTime now = DateTime.now();
      String modifiedTime =
          formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);
      Map data = {
        'state': state,
        'modifiedTime': modifiedTime,
        'code_immo_id': immo,
      };
      var url = Uri.parse(baseUrl + "/UserMobile/addImmoState");
      final response = await http.post(url,
          headers: {
            "Accept": 'application/json',
            'Content-Type': 'application/json',
            "Authorization": "$tokens"
          },
          body: jsonEncode(data));
      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> listResponse = jsonDecode(response.body);
          Provider provider = Provider();
          final db = await provider.initDB();
          await db.transaction((txnz) async {
            await txnz.rawInsert("""INSERT INTO
              ImmoState (immoStateId, state, modifiedTime, code_immo_id)
              VALUES (NULL,?,?,?)
              """, [state, modifiedTime, immo]);
          });

          return listResponse;

        default:
          return [];
      }

    case ConnectivityResult.ethernet:
      return null;
    case ConnectivityResult.mobile:
      return null;
    case ConnectivityResult.none:
      Provider provider = Provider();
      DateTime now = DateTime.now();
      final db = await provider.initDB();
      String modifiedTime = formatDate(now, [yyyy, '-', mm, '-', dd]);
      await db.transaction((txne) async {
        await txne.rawInsert("""INSERT INTO 
        ImmoState (immoStateId, state, modifiedTime, code_immo_id)
         VALUES (NULL,?,?,?)
         """, [state, modifiedTime, immo]);
      });
      List<Map<String, dynamic>> maps = [];
      await db.transaction((txn) async {
        maps = await txn.rawQuery(""" 
          select max(immoStateId) as immoStateId from ImmoState where code_immo_id=?
        """, [immo]);
      });
      return maps[0];
  }
}

//UserMobile/ImmoState
Future<dynamic> getImmostate(immo) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  switch (connectivityResult) {
    case ConnectivityResult.bluetooth:
      return null;
    case ConnectivityResult.wifi:
      Token token = Token();
      String? tokens = await token.getToken();

      Map data = {
        'code_immo_id': immo,
      };
      var url = Uri.parse(baseUrl + "/UserMobile/ImmoState");
      final response = await http.post(url,
          headers: {
            "Accept": 'application/json',
            'Content-Type': 'application/json',
            "Authorization": "$tokens"
          },
          body: jsonEncode(data));
      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> listResponse = jsonDecode(response.body);

          return listResponse;

        default:
          return [];
      }
    case ConnectivityResult.ethernet:
      return null;
    case ConnectivityResult.mobile:
      return null;
    case ConnectivityResult.none:
      Provider provider = Provider();
      final db = await provider.initDB();
      List<Map<String, dynamic>> maps = [];
      await db.transaction((txn) async {
        maps = await txn.rawQuery(""" 
          select max(immoStateId) as immoStateId from ImmoState where code_immo_id=?
        """, [immo]);
      });
      return maps[0];
  }
}

//Récupère l'id d'un code immo
//La fonction est utilisée pour l'insertion de l'historique de l'inventaire
Future<dynamic> getImmoId(immocode) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  switch (connectivityResult) {
    case ConnectivityResult.bluetooth:
      return null;
    case ConnectivityResult.wifi:
      Token token = Token();
      String? tokens = await token.getToken();
      Map data = {'code_immo_code': immocode};
      var url = Uri.parse(baseUrl + "/UserMobile/getImmobycode");
      final response = await http.post(url,
          headers: {
            "Accept": 'application/json',
            'Content-Type': 'application/json',
            "Authorization": "$tokens"
          },
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        List<dynamic> listResponse = jsonDecode(response.body);
        return listResponse;
      } else {
        return [];
      }

    case ConnectivityResult.ethernet:
      return null;
    case ConnectivityResult.mobile:
      return null;
    case ConnectivityResult.none:
      Provider provider = Provider();
      final db = await provider.initDB();
      List<Map<String, dynamic>> maps = [];
      await db.transaction((txn) async {
        maps = await txn.rawQuery("""SELECT 
        code_immo_id 
        from code_immo
        where code_immo_code=?""", [immocode]);
      });
      if (maps.isNotEmpty) {
        return maps;
      } else {
        return [];
      }
  }
}

//Envoie l'historique des personnes affectées vers le serveur
Future<dynamic> addHistoryAffectedto(
    codeImmoid, direction, stateid, userId, personId, observation) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  switch (connectivityResult) {
    case ConnectivityResult.bluetooth:
      return null;
    case ConnectivityResult.wifi:
      Token token = Token();
      String? tokens = await token.getToken();
      DateTime now = DateTime.now();
      String modifiedTime =
          formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);

      Map data = {
        "time_of_operation": modifiedTime,
        "code_immo_id": codeImmoid,
        "direction_id": direction,
        'immoStateId': stateid,
        'user_id': userId,
        "person_id": personId,
        "observation": observation,
      };
      var url = Uri.parse(baseUrl + "/UserMobile/addHistoryAffected");
      final response = await http.post(
        url,
        headers: {
          "Accept": 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "$tokens"
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> listResponse = jsonDecode(response.body);
        //Put the result into the database
        Provider provider = Provider();
        final db = await provider.initDB();
        List<Map<String, dynamic>> maps = [];
        await db.transaction((txn) async {
          maps = await txn.rawQuery("""
            select max(immoStateId) as immoStateId from ImmoState where code_immo_id=?
          """, [codeImmoid]);
        });
        await db.transaction((txne) async {
          await txne.rawInsert(
            """ INSERT
         INTO History_Affected_Material_Inventory
         (history_id, time_of_operation, code_immo_id, direction_id, immoStateId, user_id,person_id,observation)
         VALUES (NULL,?,?,?,?,?,?,?)
         """,
            [
              modifiedTime,
              codeImmoid,
              direction,
              maps[0]["immoStateId"],
              userId,
              personId,
              observation
            ],
          );
        });
        return listResponse;
      } else {
        return [];
      }

    case ConnectivityResult.ethernet:
      return null;
    case ConnectivityResult.mobile:
      return null;
    case ConnectivityResult.none:
      Provider provider = Provider();
      DateTime now = DateTime.now();
      final db = await provider.initDB();
      String modifiedTime =
          formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);
      List<Map<String, dynamic>> maps = [];
      await db.transaction((txn) async {
        maps = await txn.rawQuery("""
            select max(immoStateId) as immoStateId from ImmoState where code_immo_id=?
          """, [codeImmoid]);
      });
      await db.transaction((txnf) async {
        await txnf.rawInsert(""" INSERT OR IGNORE 
         INTO History_Affected_Material_Inventory
         (history_id, time_of_operation, code_immo_id, direction_id, immoStateId, user_id,person_id,observation)
         VALUES (NULL,?,?,?,?,?,?,?)
         """, [
          modifiedTime,
          codeImmoid,
          direction,
          maps[0]["immoStateId"],
          userId,
          personId,
          observation
        ]);
      });

      return true;
  }
}

//Envoie les matériels enregistrés et la personne affecter à ce matériel
Future<dynamic> addAffectation(codeImmoid, personId) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  switch (connectivityResult) {
    case ConnectivityResult.bluetooth:
      return null;
    case ConnectivityResult.wifi:
      Token token = Token();
      String? tokens = await token.getToken();
      DateTime now = DateTime.now();
      String modifiedTime =
          formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);

      Map data = {
        "added_time": modifiedTime,
        "code_immo_id": codeImmoid,
        'user_id': personId,
      };
      var url = Uri.parse(baseUrl + "/UserMobile/addAffectationPerson");
      final response = await http.post(url,
          headers: {
            "Accept": 'application/json',
            'Content-Type': 'application/json',
            "Authorization": "$tokens"
          },
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        Provider provider = Provider();
        DateTime now = DateTime.now();
        final db = await provider.initDB();
        String modifiedTime = formatDate(now, [yyyy, '-', mm, '-', dd]);
        await db.transaction(
          (txn) async {
            await txn.rawInsert("""INSERT OR REPLACE INTO 
        affectedto (affectedTo_id, added_time, code_immo_id, user_id)
         VALUES (NULL,?,?,?)
         """, [modifiedTime, codeImmoid, personId]);
          },
        );
        return true;
      } else {
        return [];
      }

    case ConnectivityResult.ethernet:
      return null;
    case ConnectivityResult.mobile:
      return null;
    case ConnectivityResult.none:
      Provider provider = Provider();
      DateTime now = DateTime.now();
      final db = await provider.initDB();
      String modifiedTime = formatDate(now, [yyyy, '-', mm, '-', dd]);
      await db.transaction(
        (txn) async {
          await txn.rawInsert("""INSERT OR REPLACE INTO 
        affectedto (affectedTo_id, added_time, code_immo_id, user_id)
         VALUES (NULL,?,?,?)
         """, [modifiedTime, codeImmoid, personId]);
        },
      );

      return true;
  }
}
