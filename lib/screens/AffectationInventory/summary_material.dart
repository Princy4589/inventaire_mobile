import 'package:flutter/material.dart';
import 'package:pgi_mobile/models/log.dart';
import 'package:pgi_mobile/screens/AffectationInventory/add_material.dart';
import 'package:pgi_mobile/screens/Menu/menu.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/services/online/user_service.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/screens/AffectationInventory/scan_affected_material.dart';
import 'package:pgi_mobile/services/online/scan_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecapInfo extends StatelessWidget {
  const RecapInfo({Key? key}) : super(key: key);

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

  getEntryItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //getLastLogFromDB est nécessaire au cas où l'user_id dans le local storage est null ou vide
    List<Log> log = await provider.getLastLogFromDB();

    userEntry['Directions'] = prefs.getString('Directions');
    userEntry['Service'] = prefs.getString('Service');
    userEntry['HQ'] = prefs.getString('HQ');
    userEntry['state'] = prefs.getString('state');
    userEntry['code_immo'] = prefs.getString('code_immo');
    userEntry['code_immo_id'] = prefs.getString('code_immo_id');
    userEntry["personId"] = prefs.getString("person_id");
    userEntry["user_id"] = prefs.getString('user_id') ?? log[0].userId;
    userEntry["observation"] = prefs.getString("observation");

    return userEntry;
  }

  setImmostate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //ajout de l'état des matériels dans la base de données
    await addImmostate(userEntry['state'], userEntry['code_immo_id']);
    //stateId : getImmostate permet de récupérer l'id de l'état des matériels
    // dans la base de données local mobile et serveur
    final stateId = await getImmostate(userEntry['code_immo_id']);
    List<dynamic>? listDirection = await apiservice.getDirection();
    listDirection?.forEach((element) {
      if (element is Map<String, dynamic>) {
        element.forEach((key, value) {
          if (element["code"] == userEntry['Directions']) {
            userEntry['direction_id'] = element["direction_id"];
          }
        });
      }
    });
    if (stateId != false) {
      if (stateId is List<Map<String, dynamic>>) {
        for (var element in stateId) {
          prefs.setInt('immoStateId', element["immoStateId"]);
          userEntry["immoStateId"] = element["immoStateId"];
        }
      } else if (stateId is Map<String, dynamic>) {
        prefs.setString('immoStateId', stateId["immoStateId"].toString());
        userEntry["immoStateId"] = stateId["immoStateId"];
      }
      return stateId;
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Veuillez recommencer le scan"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScanImmoAffectation())),
              child: const Text('Revenir'),
            ),
          ],
        ),
      );
      return {"error": "error"};
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          } else if (snapshot.data == {"error": "error"}) {
            return const Text("Une erreur est survenue. Veuillez recommencer.");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget setImmo(BuildContext context) {
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
          height: 438,
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
                      height: 248,
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
                                    text:
                                        "Direction : ${userEntry['Directions']}",
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
                                  TextSpan(
                                    text: " Siège : ${userEntry['HQ']}",
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
                                  TextSpan(
                                    text: " Service : ${userEntry['Service']}",
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
                                    child: Icon(Icons.qr_code_2),
                                  ),
                                  TextSpan(
                                    text:
                                        " Code Immo : ${userEntry['code_immo']}",
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
                                  TextSpan(
                                    text:
                                        " Etat Matériel : ${userEntry['state']}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Row(
                        children: const <Widget>[
                          CircularProgressIndicator(),
                          Text("  Chargement...")
                        ],
                      ),
                    ));
                    await addAffectation(
                            userEntry['code_immo_id'], userEntry['personId'])
                        .whenComplete(() async => await addHistoryAffectedto(
                              userEntry['code_immo_id'],
                              userEntry['direction_id'],
                              userEntry["immoStateId"],
                              userEntry["user_id"],
                              userEntry["personId"],
                              userEntry["observation"],
                            ).whenComplete(() => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content: const Text(
                                        "Voulez vous continuer l'affectation de matériel pour cet utilisateur?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              content: const Text(
                                                  "Voulez vous faire choisir un autre utilisateur?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Menu(),
                                                    ),
                                                  ),
                                                  child: const Text('Non'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const StaffExtension())),
                                                  child: const Text('Oui'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text('Non'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ScanImmoAffectation(),
                                            ),
                                          );
                                        },
                                        child: const Text('Oui'),
                                      ),
                                    ],
                                  ),
                                )));
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
