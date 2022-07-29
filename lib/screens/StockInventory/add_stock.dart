import 'package:flutter/material.dart';
import 'package:pgi_mobile/screens/StockInventory/immo_state.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/services/online/user_service.dart';
import 'package:pgi_mobile/utils/useful_functions.dart';

import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStock extends StatelessWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text(' Matériel stocké'),
      ),
      body: const AddStockWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class AddStockWidget extends StatefulWidget {
  const AddStockWidget({Key? key}) : super(key: key);

  @override
  State<AddStockWidget> createState() => _AddStockWidget();
}

class _AddStockWidget extends State<AddStockWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _managements = [];
  final List<Map<String, dynamic>> _headquarters = [];
  final List<Map<String, dynamic>> _storage = [];
  Map<String, dynamic> formSubmit =
      {}; //pour y enregistrer les données entrer par l'utilisateur
  UserService apiservice = UserService();
  List<bool> isEnabled = [
    false,
    false,
    false
  ]; //Pour activer le champ suivant après chaque entrer par l'utilisateur

  directionList() async {
    List<dynamic>? listDirection = await apiservice.getDirection();
    var valeur = "";
    listDirection?.forEach((element) {
      if (element is Map<String, dynamic>) {
        element.forEach((key, value) {
          if (key == "code") {
            valeur = value;
          } else if (key == "description") {
            _managements.add({"value": valeur, "label": value});
          }
        });
      }
    });
    return listDirection;
  }

  seatsList(direction) async {
    List<dynamic>? listSeat = await apiservice.getSeats(direction);
    SharedPreferences userinfo = await SharedPreferences.getInstance();
    setState(() {
      isEnabled[0] = true;
    });
    listSeat?.forEach((element) {
      if (element is Map<String, dynamic>) {
        element.forEach((key, value) {
          if (value != null) {
            if (key == "seat_id") {
              userinfo.setString("seat_id", value.toString());
            } else if (key == "seat_name") {
              _headquarters.add({"value": value, "label": value});
            }
          }
        });
      }
    });
  }

  storageList(seat) async {
    List<dynamic>? listDoor = await apiservice.getStorage(seat);
    SharedPreferences userinfo = await SharedPreferences.getInstance();
    setState(() {
      isEnabled[1] = true;
    });
    listDoor?.forEach((element) {
      if (element is Map<String, dynamic>) {
        element.forEach((key, value) {
          if (value != null) {
            if (key == "storage_id") {
              userinfo.setString("storage_id", value.toString());
            } else if (key == "storage_address") {
              _storage.add({"value": value, "label": value});
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loadDirection(),
    );
  }

  Widget loadDirection() {
    return FutureBuilder(
        future: directionList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return addStock(context);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget addStock(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 575,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: <Widget>[
                Container(
                  height: 465,
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Align(
                    alignment: Alignment.center,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            child: SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: formSubmit['Managements'],
                              icon: const Icon(Icons.account_tree),
                              labelText: 'Direction',
                              items: _managements,
                              onChanged: (value) async {
                                formSubmit['Managements'] = value;
                                await seatsList(value);
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.account_tree),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                isDense: true,
                                border: OutlineInputBorder(),
                                hintText: 'Direction',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            child: SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: formSubmit['HQ'],
                              icon: const Icon(Icons.map_sharp),
                              labelText: 'Siège',
                              items: _headquarters,
                              enabled: isEnabled[0],
                              onChanged: (value) async {
                                formSubmit['HQ'] = value;
                                await storageList(value);
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.map_sharp),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder(),
                                hintText: 'Siège',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            child: SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: formSubmit['Storages'],
                              icon: const Icon(Icons.place_sharp),

                              items: _storage,
                              enabled: isEnabled[1],
                              onChanged: (value) {
                                formSubmit['Storage'] = value;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.place_outlined),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder(),
                                hintText: 'Adresse de stockage',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(50),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(19, 62, 103, 1),
                                minimumSize: const Size.fromHeight(50),
                              ),
                              onPressed: () async {
                                if (formSubmit['Managements'] == null ||
                                    formSubmit['HQ'] == null ||
                                    formSubmit['Storage'] == null) {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text("Erreur"),
                                      content: const Text(
                                          "Veuillez remplir ces champs"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  await saveFormSubmitStock(formSubmit);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const StateMaterial(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
