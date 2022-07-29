import 'package:flutter/material.dart';
import 'package:pgi_mobile/models/log.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _Logstate();
}

class _Logstate extends State<Logs> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("immo_code"),
      ),
      body: FutureBuilder(
        future: provider.getLastLogFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Log>? immoss = snapshot.data as List<Log>?;
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

  Widget _buildListView(List<Log> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              Log immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.id.toString()),
                  subtitle: Text("user: " +
                      immo.email.toString() +
                      "\npassword : " +
                      immo.password.toString()),
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
