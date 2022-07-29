import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/user.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class UserOffline extends StatefulWidget {
  const UserOffline({Key? key}) : super(key: key);

  @override
  State<UserOffline> createState() => _UserOfflineState();
}

class _UserOfflineState extends State<UserOffline> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("immo_code"),
      ),
      body: FutureBuilder(
        future: provider.getUsersFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<User>? immoss = snapshot.data as List<User>?;
            return _buildListView(immoss!);
            // return _buildListView(persons);
          } else {
            return Center(
              child: Container(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<User> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              User immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.email + " "),
                  subtitle: Text("Numéro : " +
                      immo.userId.toString() +
                      "\nTéléphone : " +
                      immo.phoneNumber.toString()),
                  dense: true,
                  onTap: () {},
                ),
              );
            },
          )
        : const Center(
            child: SizedBox(child: Text("Aucun code immo n'a été trouvé")));
  }
}
