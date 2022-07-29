import 'package:flutter/material.dart';
import 'package:pgi_mobile/screens/Scan/material_property_entry.dart';

import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/services/online/scan_services.dart';
import 'package:pgi_mobile/utils/search_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userEntry = {};

class ManualEntry extends StatelessWidget {
  const ManualEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Code Immo Matériel'),
      ),
      body: const ManualEntryWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class ManualEntryWidget extends StatefulWidget {
  const ManualEntryWidget({Key? key}) : super(key: key);
  @override
  State<ManualEntryWidget> createState() => _ManualEntryWidget();
}

class _ManualEntryWidget extends State<ManualEntryWidget> {
  final immoController = TextEditingController();

  Future<dynamic> setImmo(immocode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = await getImmoId(immocode);

    prefs.setString("code_immo", immocode);

    if (list is bool) {
      return list;
    } else {
      list.forEach((element) {
        if (element is Map<String, dynamic>) {
          element.forEach((key, value) {
            if (value != null) {
              if (key == 'code_immo_id') {
                userEntry['code_immo_id'] = value.toString();
              }
            }
          });
        }
      });
    }
    prefs.setString("code_immo_id", userEntry['code_immo_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: manualEntry(),
    );
  }

  Widget manualEntry() {
    return Center(
      child: SingleChildScrollView(
          child: Container(
        height: 300,
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(
              child: Text(
                "Code Immo",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: immoController,
                decoration: InputDecoration(
                  label: const Text("Code Immo"),
                  border: const OutlineInputBorder(),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(1),
                    child: IconButton(
                      onPressed: () async {
                        final result = await showSearch(
                            context: context, delegate: CustomSearchDelegate());
                        immoController.text = result.toString();
                        userEntry["code_immo"] = immoController.text;
                      },
                      icon: const Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(19, 62, 103, 1),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  if (immoController.text != "") {
                    await setImmo(userEntry["code_immo"]).whenComplete(
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MaterialPropertyEntry(),
                          ),
                        );
                      },
                    );
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Erreur"),
                        content: const Text(
                            "Veuillez bien remplir les champs ci-dessus "),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Suivant'),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
