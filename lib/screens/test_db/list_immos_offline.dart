import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/code_immo.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class ImmoCodeOffline extends StatefulWidget {
  const ImmoCodeOffline({Key? key}) : super(key: key);

  @override
  State<ImmoCodeOffline> createState() => _ImmoCodeState();
}

class _ImmoCodeState extends State<ImmoCodeOffline> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("immo_code"),
      ),
      body: FutureBuilder(
        future: provider.getImmoFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<CodeImmo>? immoss = snapshot.data as List<CodeImmo>?;
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

  Widget _buildListView(List<CodeImmo> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              CodeImmo immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.codeImmoCode + " " + immo.codeName),
                  subtitle: Text("immo date: " +
                      immo.dateAcquis +
                      "\nname : " +
                      immo.name),
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
