import 'package:flutter/material.dart';
import 'package:pgi_mobile/screens/StockInventory/observation.dart';
import 'package:pgi_mobile/utils/components.dart';

import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateMaterial extends StatelessWidget {
  const StateMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Code Immo Matériel'),
      ),
      body: const CodeImmoWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class CodeImmoWidget extends StatefulWidget {
  const CodeImmoWidget({Key? key}) : super(key: key);
  @override
  State<CodeImmoWidget> createState() => _CodeImmoWidget();
}

class _CodeImmoWidget extends State<CodeImmoWidget> {
  final userEntry = {};
  final immoController = TextEditingController();

  final List<Map<String, dynamic>> _stateItem = [
    {
      'value': 'MAUVAIS ETAT',
      'label': 'Mauvais état',
    },
    {
      'value': 'BON ETAT',
      'label': 'Bon état',
    },
    {
      'value': 'ETAT MOYEN',
      'label': 'Etat moyen',
    },
    {
      'value': 'TRES BON ETAT',
      'label': 'Excellent état',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  Future setImmo(immocode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("State", userEntry['state']);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: manualEntryStock(),
    );
  }

  Widget manualEntryStock() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 300,
          height: 300,
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                child: Text(
                  "Etat matériel",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              const Divider(
                height: 40,
                thickness: 5,
                indent: 20,
                endIndent: 20,
                color: Colors.blueGrey,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  items: _stateItem,
                  controller: immoController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_tree),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: 'Etat Matériel',
                  ),

                  onChanged: (value) {
                    userEntry['state'] = value;
                    // change of value
                  },
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Row(
                          children: const <Widget>[
                            CircularProgressIndicator(),
                            Text("Chargement...")
                          ],
                        ),
                      ));
                      await setImmo(immoController.text).whenComplete(
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ObservationStock(),
                          ),
                        ),
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
        ),
      ),
    );
  }
}
