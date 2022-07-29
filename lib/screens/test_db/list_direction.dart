import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/direction.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class DirectionList extends StatefulWidget {
  const DirectionList({Key? key}) : super(key: key);

  @override
  State<DirectionList> createState() => _DirectionListState();
}

class _DirectionListState extends State<DirectionList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Directions List"),
      ),
      body: FutureBuilder(
        future: provider.getDirectionsFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Direction>? user = snapshot.data as List<Direction>?;
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

  Widget _buildListView(List<Direction> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              Direction immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.code + " " + immo.name),
                  subtitle: Text("description: " +
                      immo.description +
                      "\nname : " +
                      immo.name +
                      "\nid : " +
                      immo.directionId.toString()),
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
