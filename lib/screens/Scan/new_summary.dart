import 'package:flutter/material.dart';
import 'package:pgi_mobile/models/log.dart';
import 'package:pgi_mobile/models/person.dart';
import 'package:pgi_mobile/models/storage_address.dart';
import 'package:pgi_mobile/screens/Menu/menu.dart';
import 'package:pgi_mobile/screens/Scan/scan_inventory.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/services/online/user_service.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/services/online/scan_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Summary extends StatelessWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Résultat scan'),
      ),
      body: const RecapWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class RecapWidget extends StatefulWidget {
  const RecapWidget({Key? key}) : super(key: key);

  @override
  State<RecapWidget> createState() => _RecapWidget();
}

class _RecapWidget extends State<RecapWidget> {
  final userEntry = {};
  UserService apiservice = UserService();
  Provider provider = Provider();
  List<Map<String, dynamic>> mapsAffectation = [];
  List<Map<String, dynamic>> mapsStock = [];

  getEntryItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Log> log = await provider.getLastLogFromDB();
    userEntry['state'] = prefs.getString('state');
    userEntry['code_immo'] = prefs.getString('code_immo');
    userEntry['code_immo_id'] = prefs.getString('code_immo_id');
    userEntry["user_id"] = prefs.getString('user_id') ?? log[0].userId;
    userEntry["observation"] = prefs.getString("observation");
    userEntry["direction"] = prefs.getString("direction");
    userEntry["matériel"] = prefs.getString("matériel");
    userEntry["personne"] = prefs.getString("personne");

    // On a récupéré les données de la table historique inventaire
    //Si mapsAffectation est vide alors, on utilise mapsStock et vice versa
    mapsAffectation =
        await provider.getImmoAffectationInfoFromDB(userEntry['code_immo_id']);
    mapsStock =
        await provider.getImmoStockInfoFromDB(userEntry['code_immo_id']);
    return userEntry;
  }

  setImmostate() async {
    final stateId = await getImmostate(userEntry['code_immo_id']);
    //juste pour obtenir des infos à partir de stateId
    if (stateId != false) {
      if (stateId is List<Map<String, dynamic>>) {
        for (var element in stateId) {
          userEntry["immoStateId"] = element["immoStateId"];
        }
      } else if (stateId is Map<String, dynamic>) {
        userEntry["immoStateId"] = stateId["immoStateId"];
      }
    }
    if (mapsStock.isNotEmpty && mapsStock[0]["date"] != null) {
      for (var element in mapsStock) {
        userEntry["direction_stock"] = element["name"];
        userEntry["adresse"] = element["adresse"];
      }

      //get direction_id from the stock
      List<dynamic>? listDirectionStock = await apiservice.getDirection();
      listDirectionStock?.forEach((element) {
        if (element is Map<String, dynamic>) {
          element.forEach(
            (key, value) {
              if (element["name"] == userEntry['direction_stock']) {
                userEntry['direction_id'] = element["direction_id"];
              }
            },
          );
        }
      });

      //get storage_id from storage
      List<StorageAddress>? listStorage = await provider.getStorageFromDB();
      for (var element in listStorage) {
        if (element.storageAddress == userEntry["adresse"]) {
          userEntry["storage_id"] = element.storageId;
        }
      }

      return userEntry;
    }

    if (mapsAffectation.isNotEmpty && mapsAffectation[0]["date"] != null) {
      //get all the necessary info for the summary
      for (var element in mapsAffectation) {
        userEntry["direction_affectation"] = element["name"];
        userEntry["person"] = element["nom"];
      }

      List<dynamic>? listDirectionAffectation = await apiservice.getDirection();

      listDirectionAffectation?.forEach((element) {
        if (element is Map<String, dynamic>) {
          element.forEach(
            (key, value) {
              if (element["name"] == userEntry['direction_affectation']) {
                userEntry['direction_id'] = element["direction_id"];
              }
            },
          );
        }
      });

      //get person_id from person
      List<Person>? listperson = await provider.getPersonFromDB();
      for (var element in listperson) {
        if (element.lastName == userEntry["person"]) {
          userEntry["person_id"] = element.personId;
        }
      }
      return userEntry;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loadData(context),
    );
  }

  Widget loadData(BuildContext context) {
    return FutureBuilder(
        future: getEntryItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return setImmo(context);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget setImmo(BuildContext context) {
    return FutureBuilder(
      future: addImmostate(userEntry['state'], userEntry['code_immo_id']),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return loadImmo(context);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget loadImmo(BuildContext context) {
    return FutureBuilder(
      future: setImmostate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return manualEntry(context);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget manualEntry(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 430,
          width: 400,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 50,
                child: const Align(
                  child: Text(
                    "Résumé du matériel",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 5,
                indent: 100,
                endIndent: 100,
                color: Colors.grey,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Card(
                  color: Colors.grey,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 240,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  const WidgetSpan(
                                    child: Icon(Icons.directions),
                                  ),
                                  TextSpan(
                                    text: "${userEntry["direction"]}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  const WidgetSpan(
                                    child: Icon(Icons.map_outlined),
                                  ),
                                  const TextSpan(
                                    text: "Code Immo",
                                    style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ": ${userEntry['code_immo']}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  const WidgetSpan(
                                    child: Icon(Icons.design_services),
                                  ),
                                  const TextSpan(
                                    text: "Matériel",
                                    style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " : ${userEntry['matériel']}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  const WidgetSpan(
                                    child: Icon(Icons.build),
                                  ),
                                  const TextSpan(
                                    text: "Etat Matériel",
                                    style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " : ${userEntry['state']}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          userEntry['adresse'] != null &&
                                  userEntry['personne'] == null
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        const WidgetSpan(
                                          child: Icon(Icons.build),
                                        ),
                                        const TextSpan(
                                          text: "Adresse de stockage",
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " : ${userEntry['adresse']}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          userEntry["personne"] != null &&
                                  userEntry['adresse'] == null
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        const WidgetSpan(
                                          child: Icon(Icons.person),
                                        ),
                                        const TextSpan(
                                          text: "Appartient à",
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ": ${userEntry['personne']} ",
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(19, 62, 103, 1),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Row(
                        children: const <Widget>[
                          CircularProgressIndicator(),
                          Text("  Chargement...")
                        ],
                      ),
                    ));
                    userEntry["adresse"] == null
                        ? await addAffectation(userEntry['code_immo_id'],
                                userEntry['person_id'])
                            .whenComplete(
                                () async => await addHistoryAffectedto(
                                      userEntry['code_immo_id'],
                                      userEntry["direction_id"],
                                      userEntry['immoStateId'],
                                      userEntry["user_id"],
                                      userEntry["person_id"],
                                      userEntry["observation"],
                                    ))
                        : await addHistoryStock(
                            userEntry['code_immo_id'],
                            userEntry["direction_id"],
                            userEntry['immoStateId'],
                            userEntry["user_id"],
                            userEntry["storage_id"],
                            userEntry["observation"]);
                    prefs.remove("adresse");
                    prefs.remove("personne");
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Succès "),
                        content:
                            const Text("Voulez vous continuer l'inventaire ?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScanInventory()));
                            },
                            child: const Text('Oui'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Menu(),
                                ),
                              );
                            },
                            child: const Text('Non'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Suivant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
