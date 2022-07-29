import 'package:flutter/material.dart';
import 'package:pgi_mobile/models/log.dart';
import 'package:pgi_mobile/screens/Menu/menu.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/services/online/user_service.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/screens/StockInventory/scan_stock.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pgi_mobile/services/online/scan_services.dart';

class FinalStock extends StatelessWidget {
  const FinalStock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Résumé inventaire'),
      ),
      body: const FinalStockWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class FinalStockWidget extends StatefulWidget {
  const FinalStockWidget({Key? key}) : super(key: key);

  @override
  State<FinalStockWidget> createState() => _FinalStockWidgetState();
}

class _FinalStockWidgetState extends State<FinalStockWidget> {
  var userEntry = {};
  Provider provider = Provider();
  UserService apiservice = UserService();

  getEntryItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEntry['Directions'] = prefs.getString('Directions');
    userEntry['HQ'] = prefs.getString('HQ');
    userEntry['Storage'] = prefs.getString('Storage');
    userEntry['state'] = prefs.getString('State');
    userEntry['code_immo'] = prefs.getString('code_immo');
    userEntry['code_immo_id'] = prefs.getString("code_immo_id");
    userEntry["observation"] = prefs.getString("observation");
    return userEntry;
  }

  @override
  void initState() {
    super.initState();
  }

  setImmostate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Log> log = await provider.getLastLogFromDB();
    List<dynamic>? listDirection = await apiservice.getDirection();

    await addImmostate(userEntry['state'], userEntry['code_immo_id']);
    final stateId = await getImmostate(userEntry['code_immo_id']);
    listDirection?.forEach(
      (element) {
        if (element is Map<String, dynamic>) {
          element.forEach((key, value) {
            if (element["code"] == userEntry['Directions']) {
              userEntry['direction_id'] = element["direction_id"];
            }
          });
        }
      },
    );
    userEntry["user_id"] = prefs.getString('user_id') ?? log[0].userId;
    userEntry["storage_id"] = prefs.getString("storage_id");

    if (stateId is List<Map<String, dynamic>>) {
      for (var element in stateId) {
        prefs.setInt('immoStateId', element["immoStateId"]);
        userEntry["immoStateId"] = element["immoStateId"];
      }
      return stateId;
    } else if (stateId is Map<String, dynamic>) {
      prefs.setString('immoStateId', stateId["immoStateId"].toString());
      userEntry["immoStateId"] = stateId["immoStateId"];
      return stateId;
    } else {
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
      child: loadEntry(),
    );
  }

  Widget loadEntry() {
    return FutureBuilder(
        future: getEntryItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return loadImmo();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget loadImmo() {
    return FutureBuilder(
        future: setImmostate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return finalStock();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget finalStock() {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 500,
          width: 400,
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.all(10),
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
                      height: 270,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 250,
                            width: 400,
                            child: Center(
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
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
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
                                            style: const TextStyle(
                                                color: Colors.black),
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
                                            text:
                                                'Adresse de stockage : ${userEntry['Storage']}',
                                            style: const TextStyle(
                                                color: Colors.black),
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
                                                'Code Immo : ${userEntry['code_immo']}',
                                            style: const TextStyle(
                                                color: Colors.black),
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
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                width: 300,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(19, 62, 103, 1),
                    minimumSize: const Size.fromWidth(50),
                  ),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 3),
                      content: Row(
                        children: const <Widget>[
                          CircularProgressIndicator(),
                          Text("  Chargement...")
                        ],
                      ),
                    ));
                    await addHistoryStock(
                            userEntry['code_immo_id'],
                            userEntry['direction_id'],
                            userEntry["immoStateId"],
                            userEntry["user_id"],
                            userEntry["storage_id"],
                            userEntry["observation"])
                        .whenComplete(
                      () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                              "Votre matériel a bien été enregistrer"),
                          content: const Text(
                              "Voulez vous proccéder à l'inventaire de stock ?"),
                          actions: <Widget>[
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
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ScanStock(),
                                  ),
                                );
                              },
                              child: const Text('Oui'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
