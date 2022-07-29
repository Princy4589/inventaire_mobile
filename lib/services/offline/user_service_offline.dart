import 'package:pgi_mobile/models/affected_to.dart';
import 'package:pgi_mobile/models/code_immo.dart';
import 'package:pgi_mobile/models/direction.dart';
import 'package:pgi_mobile/models/person.dart';
import 'package:pgi_mobile/models/seats.dart';
import 'package:pgi_mobile/models/services.dart';
import 'package:pgi_mobile/models/sex.dart';
import 'package:pgi_mobile/models/storage_address.dart';
import 'package:pgi_mobile/models/traceability_service.dart';
import 'package:pgi_mobile/models/user.dart';
import 'package:pgi_mobile/utils/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:pgi_mobile/utils/token.dart';

//Offline classe pour enregistrer des données vers la base de données
//local de l'application : sqlite
class OfflineService {
  static const baseUrl = ApiUrl.baseUrl;
  Token token = Token();

  //Récupère la liste des code_immo
  Future<List<CodeImmo>> fetchImmo() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getImmoList"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );
    if (response.statusCode == 200) {
      return codeImmoFromJson(response.body);
    } else {
      return [];
    }
  }

  //Résupère la liste des utilisateurs
  Future<List<User>> fetchUsers() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getUsersList"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return userFromJson(response.body);
    } else {
      return [];
    }
  }

  //Récupère la liste des directions
  Future<List<Direction>> fetchDirections() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getDirectionsList"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return directionFromJson(response.body);
    } else {
      return [];
    }
  }

  //Récupère la liste des services
  Future<List<Service>> fetchServices() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getServicesList"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return serviceFromJson(response.body);
    } else {
      return [];
    }
  }

  //Récupère la liste des sièges
  Future<List<Seat>> fetchSeats() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getSeatsList"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return seatFromJson(response.body);
    } else {
      return [];
    }
  }

  //Récupère la liste des adresses de stockages
  Future<List<StorageAddress>> fetchStorageAddress() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getStorageList"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return storageAddressFromJson(response.body);
    } else {
      return [];
    }
  }

  //Récupère la liste des personnes dans la base de données
  Future<List<Person>> fetchPersons() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getPersonList"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return personFromJson(response.body);
    } else {
      return [];
    }
  }

  //Récupère la liste des personnes avec les matériels qui leurs sont afféctés
  Future<List<Affectedto>> fetchAffectation() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getAffectationList"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return affectedtoFromJson(response.body);
    } else {
      return [];
    }
  }

  //Récupère la liste des données dans la table traceability_service du serveur
  Future<List<TraceabilityService>> fetchTraceability() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getServiceTraceability"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return traceabilityServiceFromJson(response.body);
    } else {
      return [];
    }
  }

  //Récupère le genre
  Future<List<Sex>> fetchGenre() async {
    String? token = await this.token.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + "/UserMobile/getSex"),
      headers: {
        "Accept": 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "$token"
      },
    );

    if (response.statusCode == 200) {
      return sexFromJson(response.body);
    } else {
      return [];
    }
  }
}
