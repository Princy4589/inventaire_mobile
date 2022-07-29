import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/screens/User/list_user_affected.dart';
import 'package:pgi_mobile/services/online/user_service.dart';
import 'package:pgi_mobile/utils/useful_functions.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Staff extends StatelessWidget {
  const Staff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Matériel affecté'),
      ),
      body: const StaffWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class StaffWidget extends StatefulWidget {
  const StaffWidget({Key? key}) : super(key: key);

  @override
  State<StaffWidget> createState() => _StaffWidget();
}

class _StaffWidget extends State<StaffWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserService apiservice = UserService();

  final Map<String, dynamic> formSubmit = {};
  final List<Map<String, dynamic>> _managements = [];
  final List<Map<String, dynamic>> _headquarters = [];
  final List<Map<String, dynamic>> _services = [];

  List<bool> isEnabled = [false, false];

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

  servicesList(direction) async {
    List<dynamic>? listBuilding = await apiservice.getServices(direction);
    SharedPreferences userinfo = await SharedPreferences.getInstance();
    setState(() {
      isEnabled[1] = true;
    });
    var valeur = ""; //stock la valeur de la clé du Map()
    listBuilding?.forEach((element) {
      if (element is Map<String, dynamic>) {
        element.forEach((key, value) {
          if (value != null) {
            if (key == "code") {
              valeur = value;
              userinfo.setString("service_code", value);
            } else if (key == "name") {
              _services.add({"value": valeur, "label": value});
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
          return affectedMaterial(context);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget affectedMaterial(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 575,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  child: const Align(
                    child: Text(
                      "Recherche d'utilisateur",
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
                  height: 455,
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
                              items: _headquarters,
                              enabled: isEnabled[0],
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.map_sharp),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder(),
                                hintText: 'Siège',
                              ),

                              onChanged: (value) async {
                                formSubmit['HQ'] = value;
                                await servicesList(formSubmit['Managements']);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            child: SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: formSubmit['Service'],
                              items: _services,
                              enabled: isEnabled[1],
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.room_service),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder(),
                                hintText: 'Service',
                              ),

                              onChanged: (value) =>
                                  formSubmit['Service'] = value,
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
                                if (_formKey.currentState!.validate()) {
                                  if (formSubmit['Managements'] == null ||
                                      formSubmit['HQ'] == null ||
                                      formSubmit['Service'] == null) {
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
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content: Row(
                                        children: const <Widget>[
                                          CircularProgressIndicator(),
                                          Text("  Chargement...")
                                        ],
                                      ),
                                    ));
                                    await saveFormSubmit(formSubmit);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ListUserAffected()));
                                  }
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
