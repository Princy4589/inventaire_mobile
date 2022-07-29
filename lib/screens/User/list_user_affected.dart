import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pgi_mobile/models/user_affected.dart';
import 'package:pgi_mobile/screens/AffectationInventory/immo_state.dart';

import 'package:pgi_mobile/services/online/user_service.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListUserAffected extends StatefulWidget {
  const ListUserAffected({Key? key}) : super(key: key);

  @override
  State<ListUserAffected> createState() => _ListUserAffectedState();
}

class _ListUserAffectedState extends State<ListUserAffected> {
  UserService? apiService;
  var isLoaded = false;
  String? direction = "";
  String? seat = "";
  String? service = "";

  @override
  void initState() {
    getEntryItems();
    apiService = UserService();
    super.initState();
  }

  getEntryItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      direction = prefs.getString('Directions');
      seat = prefs.getString('HQ');
      service = prefs.getString('Service');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Liste des Utilisateurs"),
      ),
      endDrawer: fDrawer(context),
      body: FutureBuilder(
        future: apiService!.getUserAffected(direction, seat, service),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<UsersAffected>? user = snapshot.data as List<UsersAffected>?;
            return _buildListView(user!);
            // return _buildListView(persons);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<UsersAffected> users) {
    return users.isNotEmpty
        ? ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UsersAffected user = users[index];

              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Image.asset('assets/icons/profile.png'),
                    title: Text(user.firstName + " " + user.lastName),
                    subtitle: Text("Direction : " +
                        user.dir +
                        "\nSiège : " +
                        user.seat +
                        "\nService : " +
                        user.service),
                    dense: true,
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: const MaterialStateImmo()));
                      saveUser(user.personId);
                    },
                  ));
            },
          )
        : const Center(
            child: SizedBox(child: Text("Aucun utilisateur n'a été trouvé")));
  }
}
