import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:pgi_mobile/models/user_affected.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/utils/base_url.dart';
import 'package:pgi_mobile/utils/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

//une classe qui va permettre de récupérer la liste des utilisateurs et +
class UserService {
  final String baseUrl = ApiUrl.baseUrl;
  Provider provider = Provider();

  //Affiche la liste des utilisateurs connectés
  //le try {} onSocketException {} va permettre de basculer entre offline
  //et online
  Future<List<UsersAffected>> getUserAffected(direction, seat, service) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult) {
      case ConnectivityResult.bluetooth:
        return [];
      case ConnectivityResult.wifi:
        Token token = Token();
        String? tokens = await token.getToken();
        Map<String, dynamic> data = {
          "direction": direction,
          "seat": seat,
          "service": service
        };
        final response =
            await http.post(Uri.parse(baseUrl + "/UserMobile/listmobile"),
                headers: {
                  "Accept": 'application/json',
                  'Content-Type': 'application/json',
                  "Authorization": "$tokens"
                },
                body: jsonEncode(data));

        if (response.statusCode == 200) {
          return usersAffectedFromJson(response.body);
        } else {
          return [];
        }
      case ConnectivityResult.ethernet:
        return [];
      case ConnectivityResult.mobile:
        return [];
      case ConnectivityResult.none:
        final db = await provider.initDB();
        List<Map<String, dynamic>> maps = [];
        await db.transaction((txn) async {
          maps = await txn.rawQuery('''
            SELECT DISTINCT
            person.person_id,
            person.first_name,
            person.last_name,
            person.card_number as cin,
            person.card_deliverance_date as date_cin,
            person.card_deliverance_place as lieu_cin,
            person.card_duplicate_date as datep_cin,
            person.birth_date as ddn,
            person.address as adresse,
            user.user_id,
            user.name_image,
            user.registration_number as matricule,
            user.email as personnal_email,
            user.office_number as bureau,
            user.phone_number as flotte,
            user.emergency_phone as urgence,
            service.name as service,
            seats.seat_name as seat,
            direction.description as dir,
            direction.type as type
          FROM
            person
            JOIN user ON person.person_id = user.person_id
            LEFT JOIN traceability_service ON user.user_id = traceability_service.user_id
            LEFT JOIN service ON traceability_service.service_id = service.service_id
            LEFT JOIN direction ON service.direction_id=direction.direction_id 
            LEFT JOIN seats ON direction.direction_id = seats.direction_id
          WHERE
            (
              direction.code = ?
              AND seats.seat_name = ?
              AND service.code = ?
            ) 
          ''', [direction, seat, service]);
        });
        if (maps.isNotEmpty) {
          return List.generate(maps.length, (i) {
            return UsersAffected(
              personId: maps[i]['person_id'].toString(),
              firstName: maps[i]["first_name"],
              lastName: maps[i]["last_name"],
              cin: maps[i]["cin"],
              dateCin: maps[i]["date_cin"],
              lieuCin: maps[i]["lieu_cin"],
              datepCin: maps[i]["datep_cin"],
              ddn: maps[i]["ddn"],
              adresse: maps[i]["adresse"],
              userId: maps[i]["user_id"].toString(),
              nameImage: maps[i]["name_image"],
              matricule: maps[i]["matricule"].toString(),
              personnalEmail: maps[i]["personnal_email"],
              bureau: maps[i]["bureau"].toString(),
              flotte: maps[i]["flotte"].toString(),
              urgence: maps[i]["urgence"].toString(),
              service: maps[i]["service"].toString(),
              porte: maps[i]["porte"].toString(),
              seat: maps[i]["seat"].toString(),
              dir: maps[i]["dir"].toString(),
              type: maps[i]["type"].toString(),
            );
          });
        } else {
          return [];
        }
    }
  }

  //récupère la liste des directions depuis la base de données
  Future<List<dynamic>?> getDirection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        Token token = Token();
        String? tokens = await token.getToken();

        final response = await http
            .get(Uri.parse(baseUrl + "/UserMobile/directionList"), headers: {
          "Accept": 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "$tokens"
        });
        if (response.statusCode == 200) {
          List<dynamic> liste = jsonDecode(response.body);
          return liste;
        } else {
          return [];
        }

      case ConnectivityResult.none:
        final db = await provider.initDB();
        List<Map<String, dynamic>> maps = [];
        await db.transaction((txn) async {
          maps = await txn.rawQuery(
              'SELECT direction_id,code,name,description from direction');
        });

        if (maps.isNotEmpty) {
          return maps;
        } else {
          return [];
        }
      case ConnectivityResult.mobile:
        return null;
      case ConnectivityResult.ethernet:
        return null;
      case ConnectivityResult.bluetooth:
        return null;
    }
  }

  //Récupère la liste des sièges
  Future<List<dynamic>?> getSeats(direction) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult) {
      case ConnectivityResult.bluetooth:
        return null;
      case ConnectivityResult.wifi:
        Token token = Token();
        String? tokens = await token.getToken();
        Map data = {'direction': direction};
        final response =
            await http.post(Uri.parse(baseUrl + "/UserMobile/seatsList"),
                headers: {
                  "Accept": 'application/json',
                  'Content-Type': 'application/json',
                  "Authorization": "$tokens"
                },
                body: jsonEncode(data));
        if (response.statusCode == 200) {
          List<dynamic>? liste = jsonDecode(response.body);
          return liste;
        } else {
          return [];
        }

      case ConnectivityResult.ethernet:
        return null;
      case ConnectivityResult.mobile:
        return null;
      case ConnectivityResult.none:
        final db = await provider.initDB();
        List<Map<String, dynamic>> maps = [];
        await db.transaction((txn) async {
          maps = await txn.rawQuery("""
            SELECT Distinct
            seats.seat_id, seats.seat_name
            FROM seats
            LEFT JOIN direction ON seats.direction_id=direction.direction_id 
            WHERE direction.code=?
            """, [direction]);
        });
        if (maps.isNotEmpty) {
          return maps;
        } else {
          return [];
        }
    }
  }

  //Récupère la liste des services
  Future<List<dynamic>?> getServices(direction) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult) {
      case ConnectivityResult.bluetooth:
        return null;
      case ConnectivityResult.wifi:
        Token token = Token();
        String? tokens = await token.getToken();
        Map data = {"direction": direction};
        final response =
            await http.post(Uri.parse(baseUrl + "/UserMobile/ServicesList"),
                headers: {
                  "Accept": 'application/json',
                  'Content-Type': 'application/json',
                  "Authorization": "$tokens"
                },
                body: jsonEncode(data));
        if (response.statusCode == 200) {
          List<dynamic>? liste = jsonDecode(response.body);
          return liste;
        } else {
          return [];
        }

      case ConnectivityResult.ethernet:
        return null;
      case ConnectivityResult.mobile:
        return null;
      case ConnectivityResult.none:
        final db = await provider.initDB();
        List<Map<String, dynamic>> maps = [];
        await db.transaction((txn) async {
          maps = await txn.rawQuery("""
            SELECT DISTINCT
            service.code, service.name
            FROM service
            JOIN direction ON service.direction_id=direction.direction_id
            WHERE direction.code=?
            """, [direction]);
        });

        if (maps.isNotEmpty) {
          return maps;
        } else {
          return [];
        }
    }
  }

  //Récupère les adresses de stockage
  Future<List<dynamic>?> getStorage(seat) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult) {
      case ConnectivityResult.bluetooth:
        return null;
      case ConnectivityResult.wifi:
        Token token = Token();
        String? tokens = await token.getToken();
        Map data = {"seat": seat};
        final response =
            await http.post(Uri.parse(baseUrl + "/UserMobile/listStorage"),
                headers: {
                  "Accept": 'application/json',
                  'Content-Type': 'application/json',
                  "Authorization": "$tokens"
                },
                body: jsonEncode(data));
        if (response.statusCode == 200) {
          List<dynamic>? liste = jsonDecode(response.body);
          return liste;
        } else {
          return [];
        }
      case ConnectivityResult.ethernet:
        return null;
      case ConnectivityResult.mobile:
        return null;
      case ConnectivityResult.none:
        final db = await provider.initDB();
        List<Map<String, dynamic>> maps = [];
        await db.transaction((txn) async {
          maps = await txn.rawQuery("""
          SELECT storage_address.storage_id,storage_address.storage_address 
          FROM storage_address
          JOIN seats ON storage_address.seat_id = seats.seat_id
          WHERE seats.seat_name =?
            """, [seat]);
        });

        if (maps.isNotEmpty) {
          return maps;
        } else {
          return [];
        }
    }
  }
}

//Sauvegarde l'id de la personne à qui on affecte les matériels
//Cela peut change en fonction de la personne choisie
void saveUser(String personId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("person_id", personId);
}
