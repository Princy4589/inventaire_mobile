import 'package:flutter/material.dart';
import 'package:pgi_mobile/screens/AffectationInventory/affected_material.dart';
import 'package:pgi_mobile/screens/Menu/menu.dart';
import 'package:pgi_mobile/screens/Scan/scan_inventory.dart';
import 'package:pgi_mobile/screens/Scan/state_immo.dart';

import 'package:pgi_mobile/screens/StockInventory/add_stock.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaterialProperty extends StatelessWidget {
  const MaterialProperty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Résultat scan'),
      ),
      body: const MaterialWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class MaterialWidget extends StatefulWidget {
  const MaterialWidget({Key? key}) : super(key: key);

  @override
  State<MaterialWidget> createState() => _MaterialWidget();
}

class _MaterialWidget extends State<MaterialWidget> {
  Provider provider = Provider();
  List<Map<String, dynamic>> resume = [];

  @override
  void initState() {
    super.initState();
  }

  void addItemsAffectation(temp) {
    for (var element in temp) {
      userEntry["date"] = element["date"];
      userEntry["name"] = element["name"];
      userEntry["code"] = element["code"];
      userEntry["état"] = element["état"];
      userEntry["matériel"] = element["matériel"];

      if (element["nom"] != null) {
        userEntry["nom"] = element["nom"];
        userEntry["prenom"] = element["prenom"];
      }
    }
  }

  void addItemsStock(temp) {
    for (var element in temp) {
      userEntry["date"] = element["date"];
      userEntry["name"] = element["name"];
      userEntry["code"] = element["code"];
      userEntry["état"] = element["état"];
      userEntry["matériel"] = element["matériel"];
      if (element["adresse"] != null) {
        userEntry["adresse"] = element["adresse"];
      }
    }
  }

  void saveInfo(direction, codeimmo, material, affectation, address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("direction", direction);
    prefs.setString("code_immo", codeimmo);
    prefs.setString("matériel", material);
    if (address != null) {
      prefs.setString("adresse", address);
    }
    if (affectation != null) {
      prefs.setString("personne", affectation);
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
      future: provider.getImmoAffectationInfoFromDB(userEntry['code_immo_id']),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          resume = snapshot.data as List<Map<String, dynamic>>;
          addItemsAffectation(resume);
          return summaryAffectation();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget loadImmoStockInfo() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: provider.getImmoStockInfoFromDB(userEntry['code_immo_id']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            resume = snapshot.data as List<Map<String, dynamic>>;
            addItemsStock(resume);
            return summaryStock();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget summaryStock() {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 650,
          width: 450,
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
              userEntry['date'] != null &&
                      (userEntry['adresse'] != null ||
                          userEntry['adresse'] != "")
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Colors.grey,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 300,
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
                                          text: " ${userEntry['name']}",
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
                                          child: Icon(Icons.map_outlined),
                                        ),
                                        const TextSpan(
                                          text: "Code Immo",
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ": ${userEntry['code_immo']}",
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
                                        const TextSpan(
                                          text: "Matériel",
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " : ${userEntry['matériel']}",
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
                                        const TextSpan(
                                          text: "Dernière opération",
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " : ${userEntry['date']}",
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
                                          child: Icon(Icons.build),
                                        ),
                                        const TextSpan(
                                          text: "Etat Matériel",
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " : ${userEntry['état']}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                userEntry['adresse'] != null
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
                                                text:
                                                    " : ${userEntry['adresse']}",
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
                    )
                  : Container(
                      height: 220,
                      width: 500,
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        color: Colors.grey,
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: const Text(
                                      "L'inventaire de ce matériel n'a pas encore été réalisé"),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                      "Code Immo : ${userEntry['code_immo']}"),
                                ),
                              ],
                            )),
                      ),
                    ),
              userEntry['date'] != null &&
                      (userEntry['adresse'] != null ||
                          userEntry['adresse'] != "")
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              width: 2, color: Color.fromRGBO(49, 72, 133, 1)),
                          primary: const Color.fromRGBO(79, 82, 153, 1),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          saveInfo(
                              userEntry['name'],
                              userEntry['code_immo'],
                              userEntry["matériel"],
                              null,
                              userEntry['adresse']);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const StateImmoState()));
                        },
                        child: const Text("Modifier"),
                      ),
                    )
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              width: 2, color: Color.fromRGBO(49, 72, 133, 1)),
                          primary: const Color.fromRGBO(79, 82, 153, 1),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Staff()));
                        },
                        child: const Text("Affectation"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              width: 2, color: Color.fromRGBO(49, 72, 133, 1)),
                          primary: const Color.fromRGBO(109, 92, 183, 1),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddStock(),
                            ),
                          );
                        },
                        child: const Text("Stock"),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(49, 72, 133, 1),
                        minimumSize: const Size(150, 50),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanInventory(),
                          ),
                        );
                      },
                      child: const Text("Recommencer"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(49, 72, 133, 1),
                        minimumSize: const Size(150, 50),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Menu(),
                          ),
                        );
                      },
                      child: const Text("Menu"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryAffectation() {
    if (resume.isEmpty ||
        (resume[0]["date"] == null &&
            resume[0]["name"] == null &&
            resume[0]["code"] == null &&
            resume[0]["état"] == null &&
            resume[0]["matériel"] == null &&
            resume[0]["nom"] == null &&
            resume[0]["prenom"] == null)) {
      return Center(
        child: loadImmoStockInfo(),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 650,
            width: 450,
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
                userEntry['date'] != null
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          color: Colors.grey,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 300,
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
                                            text: " ${userEntry['name']}",
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
                                            child: Icon(Icons.map_outlined),
                                          ),
                                          const TextSpan(
                                            text: "Code Immo",
                                            style: TextStyle(
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ": ${userEntry['code_immo']}",
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
                                          const TextSpan(
                                            text: "Matériel",
                                            style: TextStyle(
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " : ${userEntry['matériel']}",
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
                                          const TextSpan(
                                            text: "Dernière opération",
                                            style: TextStyle(
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " : ${userEntry['date']}",
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
                                            child: Icon(Icons.build),
                                          ),
                                          const TextSpan(
                                            text: "Etat Matériel",
                                            style: TextStyle(
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " : ${userEntry['état']}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  userEntry["nom"] != null
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
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ": ${userEntry['nom']} ${userEntry['prenom']}",
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
                      )
                    : Container(
                        height: 220,
                        width: 500,
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          color: Colors.grey,
                          child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: const Text(
                                        "L'inventaire de ce matériel n'a pas encore été réalisé"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                        "Code Immo : ${userEntry['code_immo']}"),
                                  ),
                                ],
                              )),
                        ),
                      ),
                userEntry['date'] != null &&
                        (userEntry['nom'] != null || userEntry['nom'] != "")
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 2,
                                color: Color.fromRGBO(49, 72, 133, 1)),
                            primary: const Color.fromRGBO(79, 82, 153, 1),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            saveInfo(
                                userEntry['name'],
                                userEntry['code_immo'],
                                userEntry["matériel"],
                                userEntry['nom'] + " " + userEntry['prenom'],
                                null);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StateImmoState()));
                          },
                          child: const Text("Modifier"),
                        ),
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 2,
                                color: Color.fromRGBO(49, 72, 133, 1)),
                            primary: const Color.fromRGBO(79, 82, 153, 1),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Staff()));
                          },
                          child: const Text("Affectation"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 2,
                                color: Color.fromRGBO(49, 72, 133, 1)),
                            primary: const Color.fromRGBO(109, 92, 183, 1),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddStock(),
                              ),
                            );
                          },
                          child: const Text("Stock"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(49, 72, 133, 1),
                          minimumSize: const Size(150, 50),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScanInventory(),
                            ),
                          );
                        },
                        child: const Text("Recommencer"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(49, 72, 133, 1),
                          minimumSize: const Size(150, 50),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Menu(),
                            ),
                          );
                        },
                        child: const Text("Menu"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
