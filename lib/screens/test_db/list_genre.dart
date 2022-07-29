import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/sex.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class SexList extends StatefulWidget {
  const SexList({Key? key}) : super(key: key);

  @override
  State<SexList> createState() => _SexListState();
}

class _SexListState extends State<SexList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Genre List"),
      ),
      body: FutureBuilder(
        future: provider.getGenreFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Sex>? user = snapshot.data as List<Sex>?;
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

  Widget _buildListView(List<Sex> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              Sex immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.sexId.toString() + " " + immo.name),
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
