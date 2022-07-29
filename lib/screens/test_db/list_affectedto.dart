import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/affected_to.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class AffectedtoList extends StatefulWidget {
  const AffectedtoList({Key? key}) : super(key: key);

  @override
  State<AffectedtoList> createState() => _AffectedtoListState();
}

class _AffectedtoListState extends State<AffectedtoList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Affectedtos List"),
      ),
      body: FutureBuilder(
        future: provider.getAffectationFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Affectedto>? user = snapshot.data as List<Affectedto>?;
            return _buildListView(user!);
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

  Widget _buildListView(List<Affectedto> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              Affectedto immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title:
                      Text(immo.addedTime + " " + immo.affectedToId.toString()),
                  subtitle: Text("immo date: " + immo.codeImmoId.toString()),
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
